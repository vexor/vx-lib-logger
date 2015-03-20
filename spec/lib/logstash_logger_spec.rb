require 'spec_helper'

describe Vx::Lib::Logger::LogstashLogger do

  before do
    ENV['LOGSTASH_HOST'] = 'localhost:19999'

    @log = Vx::Lib::Logger::LogstashLogger.new
    assert @log
  end

  after do
    ENV['LOGSTASH_HOST'] = nil
  end

  [:fatal, :warn, :debug, :error, :info].each do |m|
    it "should write #{m} message" do
      re = with_socket do
        @log.public_send(m, "send #{m}")
        @log.wait
        @log.close
      end
      assert_match(/send #{m}/, re)
    end
  end

  it "should write message with params" do
    re = with_socket do
      @log.info "text message", param: :value
      @log.wait
      @log.close
    end
    assert_match(/text message/, re)
    assert_match(/"param":/, re)
    assert_match(/:"value"/, re)
  end

  it "should write message with exception in params" do
    re = with_socket do
      @log.info "text message", exception: Exception.new("got!")
      @log.wait
      @log.close
    end
    assert_match(/text message/, re)
    assert_match(/"exception":/, re)
    assert_match(/:"Exception - got!"/, re)
  end

  it "should dump invalid unicode key" do
    re = with_socket do
      @log.info "Le Caf\xc3\xa9 \xa9", key: "Le Caf\xc3\xa9 \xa9"
      @log.wait
      @log.close
    end
    assert_match(/Le Caf/, re)
  end

end
