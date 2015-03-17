require 'socket'
require 'uri'
require 'thread'

module Vx ; module Lib ; module Logger

  class LogstashDevice

    def initialize
      @mutex = Mutex.new
      @queue = Queue.new
    end

    def uri
      @uri ||=
        begin
          h = ENV['LOGSTASH_HOST']
          URI("logstash://#{h}") if h
        end
    end

    def enabled?
      !!uri
    end

    def connected?
      !!@io
    end

    def close
      @mutex.synchronize do
        begin
          @io && @io.close
        rescue Exception => e
          warn "#{self.class} - #{e.class} - #{e.message}"
        ensure
          @io = nil
        end
      end
    end

    def write(message)
      if enabled?
        logger_thread
        @queue.push message
      end
    end

    def flush
      @mutex.synchronize do
        @io && @io.flush
      end
    end

    def wait
      while !@queue.empty?
        sleep 0.1
      end
    end

    def logger_thread
      @logger_loop ||= Thread.new do
        loop do
          m = @queue.pop
          with_connection do
            @io.write m
          end
        end
      end
    end

    private

    def host
      uri.host
    end

    def port
      @port ||= uri.port || 514
    end

    def warn(msg)
      $stderr.puts "[warn ] #{msg}"
    end

    def with_connection(&block)
      connect unless connected?
      yield
    rescue Exception => e
      warn "#{self.class} - #{e.class} - #{e.message}"
      close
    end

    def connect
      @io = TCPSocket.new(host, port).tap do |socket|
        socket.sync = true
      end
    end

  end

end ; end ; end
