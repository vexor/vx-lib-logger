require 'spec_helper'

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

  it "should successfuly lost connection" do
    log = Vx::Lib::Logger::LogstashDevice.new

    re = with_socket do
      log.write("Hello\n")
      log.close
    end

    log.write("Lost\n")

    re << with_socket do
      log.write("World\n")
    end

    log.close

    assert_equal re, "Hello\nWorld\n"
  end


end
