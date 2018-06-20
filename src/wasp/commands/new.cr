class Wasp::Command
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
