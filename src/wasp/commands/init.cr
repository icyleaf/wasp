class Wasp::Command
  class Init < GlobalOptions
    class Help
      caption "Initialize a new site"
    end

    def run
      super

      Terminal::UI.important "To be continue"
    end
  end
end
