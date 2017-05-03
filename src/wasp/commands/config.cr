class Wasp::Command
  class Config < GlobalOptions
    class Help
      caption "Print site configuration"
    end

    def run
      path = args.source? ? args.source : "."
      config_file = config_file(path)
      return UI.error("Not found config file.") unless File.file?(config_file)

      config = YAML.parse(File.read(config_file))
      config.each do |k, v|
        puts "#{k}: #{v}"
      end
    end

    private def config_file(source_path)
      source_path = File.expand_path(source_path)

      if File.directory?(source_path)
        File.join(source_path, "config.yml")
      else
        source_path
      end
    end
  end
end
