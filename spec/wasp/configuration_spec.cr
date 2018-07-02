require "../spec_helper"

private def load_config(file : String)
  path = File.expand_path("../../fixtures/configs", __FILE__)
  Wasp::Configuration.new(File.join(path, file))
end

describe Wasp::Configuration do
  describe "#initialize" do
    it "should returns same as YAML::Any" do
      config = load_config("config.yml")
      config.file.ends_with?("config.yml").should be_true

      config["title"].should eq "Wasp"
    end
  end

  describe "#decode" do
    it "should decode full config to a struct" do
      config = load_config("config.yml")
      site = Wasp::Configuration.decode(config, Wasp::Configuration::SiteStruct)
      site.title.should eq "Wasp"
    end

    it "should decode a key of config to a struct" do
      config = load_config("config_with_social.yml")
      social = Wasp::Configuration.decode(config, "social", Wasp::Configuration::SocialStruct)
      if s = social
        s.twitter.should eq "icyleaf"
      end
    end

    it "throws an exception if not exists the key" do
      config = load_config("config_with_social.yml")
      expect_raises Wasp::ConfigDecodeError do
        Wasp::Configuration.decode(config, "foobar", Wasp::Configuration::SocialStruct)
      end
    end
  end
end
