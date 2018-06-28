module Wasp
  class Command < Cli::Supercommand
    command "c", aliased: "config"

    class Config < GlobalOptions
      class Help
        caption "Print site configuration"
      end

      def run
        path = args.source? ? args.source : "."
        config = Configuration.load_file(path).as_h
        config.each do |k, v|
          puts "#{k}: #{v}"
        end
      rescue e : NotFoundFileError
        Terminal::UI.error e.message
      end
    end
  end
end
