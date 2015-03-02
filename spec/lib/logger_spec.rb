require 'spec_helper'

describe Vx::Lib::Logger do
  it "should get a new instance" do
    inst = Vx::Lib::Logger.get
    assert inst
  end

  it "should get default instance" do
    inst = Vx::Lib::Logger.default
    assert inst
  end

end
