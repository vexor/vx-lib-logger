require File.expand_path("../../lib/vx/lib/logger", __FILE__)

require 'minitest/spec'
require 'minitest/autorun'

def with_socket
  out  = ""
  server = TCPServer.new 9999

  th = Thread.new do
    loop do
      client = server.accept
      out << client.gets
      client.close
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
