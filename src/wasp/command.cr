require "cli"

module Wasp
  class Command < Cli::Supercommand
    class Help
      title "Wasp is a tool of static site generator, used to build your site."
      header "Complete documentation is available at http://github.com/icyleaf/wasp/."
      footer "Use 'wasp [command] --help' for more information about a command."
    end

    class Options
      help
    end
  end
end

require "./commands/*"
