class Wasp::Command::New
  class Content < Cli::Command
    class Help
      caption "Create a new content"
    end

    def run
      puts "new content"
    end
  end
end
