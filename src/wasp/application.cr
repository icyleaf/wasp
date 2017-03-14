require "logger"

module Wasp
  alias Any = Array(String|Int32)|Hash(Any, Any)
  class Application
    property config
    @config : Config

    def initialize(@path = Dir.current)
      @config = Wasp::Config.new(@path)
    end

  end
end
