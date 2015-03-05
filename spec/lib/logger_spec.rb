require 'spec_helper'

describe Vx::Lib::Logger do
  it "should get a new instance of stdout logger" do
    inst = Vx::Lib::Logger.get
    assert inst
  end

end
