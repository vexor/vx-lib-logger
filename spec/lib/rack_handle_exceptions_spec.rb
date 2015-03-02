require 'spec_helper'

describe Vx::Lib::Logger::Rack::HandleExceptions do

  it "should run successfuly" do
    app    = ->(env) { env }
    handle = Vx::Lib::Logger::Rack::HandleExceptions.new(app)
    re = handle.call('env')
    assert_equal re, 'env'
  end

  it "should run with exception" do
    app    = ->(env) { raise 'got!' }
    handle = Vx::Lib::Logger::Rack::HandleExceptions.new(app)
    re = handle.call({})
    assert_nil re
  end

end
