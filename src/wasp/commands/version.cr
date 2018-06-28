module Wasp
  class Command < Cli::Supercommand
    command "v", aliased: "version"

    class Version < GlobalOptions
      class Help
        caption "Print version of Wasp"
      end

      def run
        super

        Terminal::UI.message "#{Wasp::NAME} - #{Wasp::DESC} v#{Wasp::VERSION} in Crystal v#{Crystal::VERSION}"
      end
    end
  end
end
