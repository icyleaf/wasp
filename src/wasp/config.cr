require "yaml"

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
