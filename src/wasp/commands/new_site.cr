class Wasp::Command::New
  class Site < Cli::Command
    class Help
      caption "Create a new site"
    end

    def run
      puts "new site"
    end
  end
end
