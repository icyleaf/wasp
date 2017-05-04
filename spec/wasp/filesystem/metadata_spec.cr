require "../../spec_helper"

private def empty_metadata
  Wasp::FileSystem::Metadata.new("")
end

describe Wasp::FileSystem::Metadata do
  describe "parse" do
    it "works with initialize with mpty string" do
      empty_metadata.should be_a(Wasp::FileSystem::Metadata)
    end

    it "works with instance method" do
      Wasp::FileSystem::Metadata.parse("").should be_a(Wasp::FileSystem::Metadata)
    end

    it "raise exception without YAML data" do
      expect_raises do
        Wasp::FileSystem::Metadata.parse("not-yaml-data")
      end
    end
  end

  describe "gets empty" do
    it "return empty with title" do
      m = empty_metadata
      m.title.should eq("")
    end

    it "return empty with missing key" do
      m = empty_metadata
      m.not_found_key.should eq("")
    end

    it "return unix time since 1970" do
      m = empty_metadata
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

      m = Wasp::FileSystem::Metadata.new(text)
      m.title.should eq("Getting Started")
      m.slug.should eq("getting-started")
      m.date.should eq(Time.parse("2017-05-01T15:00:31+08:00", Wasp::FileSystem::Metadata::WASP_DATE_FORMAT))
      m.categories.should eq(["Guide"])
      m.tags.should eq([ "documents", "install" ])

      m.author.should eq([ "icyleaf", "Wang Shen" ])
      m.author.not_nil!.size.should eq(2) # because YAML::Type alias include Nil :(
    end

    it "tags accept string" do
      m = Wasp::FileSystem::Metadata.new("---\ntags: crystal")
      m.tags.should eq([ "crystal" ])
    end

    it "tags accept empty string" do
      m = Wasp::FileSystem::Metadata.new("---\ntags: ")
      m.tags.should eq([] of YAML::Type)
    end

    it "tags accept array" do
      m = Wasp::FileSystem::Metadata.new("---\ntags: \n  - crystal\n  - \"ruby\"")
      m.tags.should eq(["crystal", "ruby"])
    end

    it "tags raise exception with hash" do
      expect_raises do
        Wasp::FileSystem::Metadata.new("---\ntags:\n  crystal : Crystal").tags
      end
    end

    it "categories accept string" do
      m = Wasp::FileSystem::Metadata.new("---\ncategories: crystal")
      m.categories.should eq([ "crystal" ])
    end

    it "categories accept empty string" do
      m = Wasp::FileSystem::Metadata.new("---\ncategories: ")
      m.categories.should eq([] of YAML::Type)
    end

    it "categories accept array" do
      m = Wasp::FileSystem::Metadata.new("---\ncategories: \n  - crystal\n  - \"ruby\"")
      m.categories.should be_a(Array(YAML::Type))
      m.categories.should eq([ "crystal", "ruby"])
    end

    it "categories raise exception with hash" do
      expect_raises do
        Wasp::FileSystem::Metadata.new("---\ncategories:\n  crystal : Crystal").categories
      end
    end
  end
end
