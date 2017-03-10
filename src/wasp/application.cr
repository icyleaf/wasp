module Wasp
  class Application
    property logger, config

    def initialize
      @logger = Logger.new(STDOUT)
      @config = Wasp::Config.instance
    end
  end
end
