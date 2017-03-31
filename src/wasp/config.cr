require "yaml"
require "json"

module Wasp
  class Config
    property site, page
    @config_file : String
    @site : YAML::Any
    @page : YAML::Any

    def initialize(@config_file = Dir.current)
      UI.crash("Not found config file~~~~") unless File.file?(config_path)

      @site = YAML.parse(File.read(config_path))
      @page = YAML.parse("")
    end

    private def config_path
      return @config_file if @config_file && File.file?(@config_file)

      @config_file = File.expand_path(@config_file)
      @config_file = File.join(@config_file, default_config_file) if File.directory?(@config_file)

      @config_file
    end

    private def default_config_file
      @default_config_file ||= "config.yml"
    end

    # private def default_config
    #   @site = {
    #     "title": "",
    #     "subtitle": "",
    #     "description": "",
    #     "timezone": "Asia/Shanghai",
    #     "base_url": "http://localhost",
    #     "theme": "nest",
    #     "permalink": ":year/:month/:day/:title/",
    #     "per_page": 10
    #   }
    # end
  end
end

struct YAML::Any
  def to_json(json : JSON::Builder)
    case object = @raw
    when Array
      json.array do
        each &.to_json(json)
      end
    when Hash
      json.object do
        each do |key, value|
          json.field key do
            value.to_json(json)
          end
        end
      end
    when "true"
      json.bool(true)
    when "false"
      json.bool(false)
    when Nil
      json.null
    when ""
      json.null
    when /^[+-]?([0-9]*[.])?[0-9]+$/
      object.includes?(".") ? json.number(object.to_f) : json.number(object.to_i)
    else
      json.string(object)
    end
  end
end
