require "../spec_helper"

private def load_config(file : String)
  Wasp::Configuration.load_file(file)
end

describe Wasp::Configuration do
  describe ".load_file" do
    it "should parse file" do
      config = load_config("./docs/config.yml")
      config.should be_a YAML::Any
      config["title"].should eq "Wasp"
    end
  end
end
