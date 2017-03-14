class Wasp::Command
  class Config < GlobalOptions
    class Help
      caption "Print site configuration"
    end

    def run
      path = args.path? ? args.path : "."
      config = Wasp::Config.new(File.expand_path(path))
      config.site.each do |k, v|
        puts "#{k}: #{v}"
      end
    rescue e
      puts e
    end
  end
end
