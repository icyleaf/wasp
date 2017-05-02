class Wasp::Command
  class Version < Cli::Command
    class Help
      caption "Print version of Wasp"
    end

    def run
      puts "#{Wasp::NAME} - #{Wasp::DESC} v#{Wasp::VERSION} in Crystal v#{Crystal::VERSION}"
    end
  end
end
