require 'spec_helper'

require 'stringio'

describe Vx::Lib::Logger::StdoutLogger do

  before do
    @out = StringIO.new
    @log = Vx::Lib::Logger::StdoutLogger.new(@out)
    assert @log
  end

  [:fatal, :warn, :debug, :error, :info].each do |m|
    it "should write #{m} message" do
      @log.public_send(m, "send #{m}")
      level = m.length < 5 ? "#{m} " : m
      text = "[#{level}] send #{m}\n"
      assert_equal text, get_out
    end
  end

  it "should write message with params" do
    @log.info "text message", param: :value
    text = "[info ] text message {\"param\":\"value\"}\n"
    assert_equal text, get_out
  end

  it "should write message with object in params" do
    @log.info "object message", param: Exception.new("foo")
    assert get_out
  end

  it "should write message with exception in params" do
    @log.info "text message", exception: Exception.new("got!")
    text = "[info ] text message {\"exception\":\"Exception - got!\",\"backtrace\":\"\"}\n"
    assert_equal text, get_out
  end

  it "should handle block" do
    @log.handle "text message" do
      sleep 0.1
    end
    assert_match(/text message/, get_out)

    begin
      @log.handle "text message", key: :value do
        raise 'got!'
      end
    rescue Exception
    end

    body = get_out
    assert_match(/key/, body)
    assert_match(/value/, body)
    assert_match(/got\!/, body)
    assert_match(/backtrace/, body)
  end

  it "should dump invalid unicode key" do
    @log.info "Le Caf\xc3\xa9 \xa9", key: "Le Caf\xc3\xa9 \xa9"
    text = "[info ] Le Café \xA9 {\"key\":\"Le Café \xA9\"}\n"
    assert_equal text, get_out
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
