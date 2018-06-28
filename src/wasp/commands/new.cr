module Wasp
  class Command < Cli::Supercommand
    command "n", aliased: "new"

    class New < GlobalOptions
      class Help
        caption "Create a new content(post, page etc)"
      end

      def run
        super

        Terminal::UI.important "To be continue"
      end
    end
  end
end
