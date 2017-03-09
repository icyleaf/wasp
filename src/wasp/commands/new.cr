class Wasp::Command
  class New < Cli::Supercommand
    command "content", default: true

    class Help
      caption "Create new content for your site"
    end

    class Options
      help
    end
  end
end
