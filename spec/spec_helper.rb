require File.expand_path("../../lib/vx/lib/logger", __FILE__)

require 'minitest/spec'
require 'minitest/autorun'
require 'thread'

def with_socket
  out    = ""
  server = TCPServer.new 9999
  lock   = Mutex.new

  ths = (0..10).to_a.map do |n|
    Thread.new do
      loop do
        client = server.accept
        lock.synchronize do
          out << client.gets
          puts "#{n}: !!!#{out}!!!"
          client.close
        end
      end
    end
  end

  begin
    yield
    sleep 10
    out
  ensure
    ths.map(&:kill)
    server.close
  end
end
