require "yaml"

module Wasp
  class Config
    property data

    def initialize(path : String)
      @default_config_file = "config.yml"
      @config_file = path || @default_config_file
      @config_file = File.join(@config_file, @default_config_file) if File.directory?(@config_file)

      raise "Not fount config file" unless File.exists?(@config_file)

      @data = ConfigItem.from_yaml(File.read_lines(@config_file).join("\n"))
    end
  end

  class ConfigItem
    YAML.mapping(
      title: String,
      subtitle: String,
      description: String,
      author: String
    )
  end
end
