module Wasp
  class Error < Exception
    property options
    def initialize(@message, @options = {} of Any => Any); end
  end
end
