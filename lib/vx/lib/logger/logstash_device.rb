require 'socket'
require 'uri'
require 'thread'

module Vx ; module Lib ; module Logger

  class LogstashDevice

    def initialize
      @mutex = Mutex.new
    end

    def uri
      @uri ||= begin
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
      @io && @io.close
    rescue Exception => e
      warn "#{self.class} - #{e.class} - #{e.message}"
    ensure
      @io = nil
    end

    def write(message)
      if enabled?
        @mutex.synchronize do
          with_connection do
            @io.write message
          end
        end
      end
    end

    def flush
      @io && @io.flush
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
        @io = nil
      end

      def reconnect
        @io = nil
        connect
      end

      def connect
        @io = TCPSocket.new(host, port).tap do |socket|
          socket.sync = true
        end
      end

  end

end ; end ; end
