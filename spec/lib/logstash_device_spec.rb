require 'spec_helper'
require 'timeout'

describe Vx::Lib::Logger::LogstashDevice do

  before do
    ENV['LOGSTASH_HOST'] = 'localhost:9999'
  end

  after do
    ENV['LOGSTASH_HOST'] = nil
  end

  it "should successfuly connect" do
    re = with_socket do
      log = Vx::Lib::Logger::LogstashDevice.new
      log.write("Hello\n")
      log.close
    end
    assert_equal re, "Hello\n"
  end

  it "should successfuly write in multhreaded" do
    re = with_socket do
      log = Vx::Lib::Logger::LogstashDevice.new
      ths = (0...3).to_a.map do |n|
        Thread.new do
          log.write("Hello\n")
        end
      end
      ths.map(&:join)
      Timeout.timeout(3) do
        while !log.empty?
          sleep 0.1
        end
      end
      log.close
    end
    assert_equal "Hello\n" * 10, re
  end

  it "should successfuly lost connection" do
    log = Vx::Lib::Logger::LogstashDevice.new

    re = with_socket do
      log.write("Hello\n")
      log.close
    end

    Timeout.timeout(3) do
      while !log.empty?
        sleep 0.1
      end
    end

    log.write("Lost\n")

    Timeout.timeout(3) do
      while !log.empty?
        sleep 0.1
      end
    end

    re << with_socket do
      log.write("World\n")
    end

    Timeout.timeout(3) do
      while !log.empty?
        sleep 0.1
      end
    end

    log.close

    assert_equal "Hello\nWorld\n", re
  end


end
