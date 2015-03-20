require 'spec_helper'

describe Vx::Lib::Logger::LogstashDevice do

  before do
    ENV['LOGSTASH_HOST'] = 'localhost:19999'
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
    assert_match(/^Hello\n/, re)
  end

  it "should successfuly lost connection" do
    log = Vx::Lib::Logger::LogstashDevice.new

    re = with_socket do
      log.write("Hello\n")
      with_timeout { log.wait }
    end
    log.close

    log.write("Lost\n")
    with_timeout { log.wait }

    re << with_socket do
      log.write("World\n")
      with_timeout { log.wait }
    end
    log.close

    assert_equal "Hello\nWorld\n", re
  end


end
