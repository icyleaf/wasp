require "../../spec_helper"

private def empty_front_matter
  Wasp::FileSystem::FrontMatter.new("", "Asia/Shanghai")
end

describe Wasp::FileSystem::FrontMatter do
  describe "parse" do
    it "works with initialize with empty string" do
      empty_front_matter.should be_a(Wasp::FileSystem::FrontMatter)
    end

    it "raise exception without YAML data" do
      expect_raises Wasp::FrontMatterParseError do
        Wasp::FileSystem::FrontMatter.parse("not-yaml-data", "Asia/Shanghai")
      end
    end
  end

  describe "gets empty" do
    it "return empty with title" do
      m = empty_front_matter
      m.title.should eq("")
    end

    it "return empty with missing key" do
      m = empty_front_matter
      m.not_found_key.should eq("")
    end

    it "return unix time since 1970" do
      m = empty_front_matter
      m.date.should be_a(Time)
      m.date.year.should eq(1970)
      m.date.month.should eq(1)
      m.date.day.should eq(1)
      m.date.hour.should eq(0)
      m.date.minute.should eq(0)
      m.date.second.should eq(0)
    end
  end

  describe "gets" do
    it "should get each key from yaml data" do
      text = <<-YAML
      ---
      title: "Getting Started"
      slug: "getting-started"
      date: "2017-05-01T15:00:31+08:00"
      categories: Guide
      tags:
        - documents
        - install
      author: [icyleaf, "Wang Shen"]
      YAML

      m = Wasp::FileSystem::FrontMatter.new(text, "Asia/Shanghai")
      m.title.should eq("Getting Started")
      m.slug.should eq("getting-started")
      m.date.should eq(Time.parse("2017-05-01T15:00:31+08:00", Wasp::FileSystem::FrontMatter::WASP_DATE_FORMAT, Time::Location.load("Asia/Shanghai")))
      m.categories.should eq(["Guide"])
      m.tags.should eq(["documents", "install"])

      m.author.should eq(["icyleaf", "Wang Shen"])
      m.author.not_nil!.size.should eq(2) # because YAML::Type alias include Nil :(
    end

    it "tags accept string" do
      m = Wasp::FileSystem::FrontMatter.new("---\ntags: crystal", "Asia/Shanghai")
      m.tags.should eq(["crystal"])
    end

    it "tags accept empty string" do
      m = Wasp::FileSystem::FrontMatter.new("---\ntags: ", "Asia/Shanghai")
      m.tags.should eq([] of YAML::Any)
    end

    it "tags accept array" do
      m = Wasp::FileSystem::FrontMatter.new("---\ntags: \n  - crystal\n  - \"ruby\"", "Asia/Shanghai")
      m.tags.should eq(["crystal", "ruby"])
    end

    it "tags returns empty without string or array" do
      m = Wasp::FileSystem::FrontMatter.new("---\ntags:\n  crystal : Crystal", "Asia/Shanghai")
      m.tags.should eq([] of YAML::Any)
    end

    it "categories accept string" do
      m = Wasp::FileSystem::FrontMatter.new("---\ncategories: crystal", "Asia/Shanghai")
      m.categories.should eq(["crystal"])
    end

    it "categories accept empty string" do
      m = Wasp::FileSystem::FrontMatter.new("---\ncategories: ", "Asia/Shanghai")
      m.categories.should eq([] of YAML::Any)
    end

    it "categories accept array" do
      m = Wasp::FileSystem::FrontMatter.new("---\ncategories: \n  - crystal\n  - \"ruby\"", "Asia/Shanghai")
      m.categories.should eq(["crystal", "ruby"])
    end

    it "categories returns empty without string or array" do
      m = Wasp::FileSystem::FrontMatter.new("---\ncategories:\n  crystal : Crystal", "Asia/Shanghai")
      m.categories.should eq([] of YAML::Any)
    end
  end
end
