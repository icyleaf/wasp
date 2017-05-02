class Wasp::Command
  class Version < GlobalOptions
    class Help
      caption "Print version of Wasp"
    end

    def run
      super

      puts "#{Wasp::NAME} - #{Wasp::DESC} v#{Wasp::VERSION} in Crystal v#{Crystal::VERSION}"
    end
  end
end
