class Wasp::Command
  class Server < Cli::Supercommand
    class Help
      caption "Run a web server"
    end

    class Options
      help
    end

    def run
      puts "run a web server"
    end
  end
end
