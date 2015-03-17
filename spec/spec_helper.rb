require File.expand_path("../../lib/vx/lib/logger", __FILE__)

require 'minitest/spec'
require 'minitest/autorun'
require 'timeout'

def with_timeout(tm=3)
  Timeout.timeout(tm) { yield }
end

def with_socket
  out  = ""
  server = TCPServer.new 9999

  th = Thread.new do
    loop do
      Thread.fork(server.accept) do |client|
        out << client.gets
        client.close
      end
    end
  end

  begin
    yield
    sleep 0.2
    out
  ensure
    th.kill
    server.close
  end
end
