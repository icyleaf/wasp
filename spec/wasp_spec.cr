require "./spec_helper"

describe Wasp do
  it "should has a name" do
    Wasp::NAME.should eq "Wasp"
  end

  it "should has a version" do
    Wasp::VERSION.should_not eq ""
  end

  it "should has a description" do
    Wasp::DESC.should_not eq ""
  end
end
