require "../spec_helper"

private def load_config(file : String)
  path = File.expand_path("../../fixtures/configs", __FILE__)
  Wasp::Configuration.configure(File.join(path, file))
end

describe Wasp::Configuration do
  describe "#initialize" do
    it "should returns same as YAML::Any" do
      config = load_config("config.yml")

      config["title"].should eq "Wasp"
      config["subtitle"].should eq "A Static Site Generator"
      config["description"].should eq "Wasp is a Static Site Generator written in Crystal."
      config["timezone"].should eq "Asia/Shanghai"
      config["base_url"].should eq "https://icyleaf.github.io/wasp/"
      config["permalink"].should eq ":section/:title/"
      config["ugly_url"].should be_false
    end
  end

  describe "#mapping" do
    it "should mapping full config to a struct" do
      config = load_config("config.yml")
      site = config.mapping(Wasp::Configuration::SiteStruct)
      site.title.should eq "Wasp"
    end

    it "should mapping a key of config to a struct" do
      config = load_config("config_with_social.yml")
      social = config.mapping(Wasp::Configuration::SocialStruct, "social")
      if s = social
        s.twitter.should eq "icyleaf"
      end
    end

    it "throws an exception if not exists the key" do
      config = load_config("config_with_social.yml")
      expect_raises Totem::MappingError do
        config.mapping(Wasp::Configuration::SocialStruct, "null")
      end
    end
  end
end
