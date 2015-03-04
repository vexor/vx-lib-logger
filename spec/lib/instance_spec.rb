require 'spec_helper'

require 'stringio'

describe Vx::Lib::Logger::Instance do

  before do
    @out = StringIO.new
    @log = Vx::Lib::Logger.get(@out)
    assert @log
  end

  [:fatal, :warn, :debug, :error, :info].each do |m|
    it "should write #{m} message" do
      @log.public_send(m, "send #{m}")
      text = "[#{m}] send #{m} :--: {\"thread_id\":#{tid}}\n"
      assert_equal text, get_out
    end
  end

  it "should write message with params" do
    @log.info "text message", param: :value
    text = "[info] text message :--: {\"thread_id\":#{tid},\"fields\":{\"param\":\"value\"}}\n"
    assert_equal text, get_out
  end

  it "should write message with object in params" do
    @log.info "object message", param: Exception.new("foo")
    assert get_out
  end

  it "should write message with exception in params" do
    @log.info "text message", exception: Exception.new("got!")
    text = "[info] text message :--: {\"thread_id\":#{tid},\"fields\":{\"exception\":\"Exception - got!\",\"backtrace\":\"\"}}\n"
    assert_equal text, get_out
  end

  it "should handle block" do
    @log.handle "text message" do
      sleep 0.1
    end
    assert_match(/duration/, get_out)

    begin
      @log.handle "text message", key: :value do
        raise 'got!'
      end
    rescue Exception
    end

    body = get_out
    assert_match(/duration/, body)
    assert_match(/key/, body)
    assert_match(/value/, body)
    assert_match(/got\!/, body)
    assert_match(/backtrace/, body)
  end

  it "should dump invalid unicode key" do
    @log.info "Le Caf\xc3\xa9 \xa9", key: "Le Caf\xc3\xa9 \xa9"
    text = "[info] Le Café \xA9 :--: {\"thread_id\":#{tid},\"fields\":{\"key\":\"Le Café \xA9\"}}\n"
    assert_equal text, get_out
  end

  it "should write message with logstash" do
    begin
      ENV['LOGSTASH_HOST'] = 'localhost:9999'
      log = Vx::Lib::Logger.get(@out)
      re = with_socket do
        log.info "Hello"
      end
      assert_match(/Hello/, re)
      assert_match(/Hello/, get_out)
    ensure
      ENV['LOGSTASH_HOST'] = nil
    end
  end

  def get_out
    @out.rewind
    body = @out.read
    @out.rewind
    body
  end

  def tid
    Thread.current.object_id
  end

  def pid
    Process.pid
  end

end
