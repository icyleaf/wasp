require "colorize"
require "logger"

module Wasp::Commands::Helper
  alias Formatter = String, Time, String, String, IO ->
  class UI

    def initialize
      @log = Logger.new(STDOUT)
      @log.formatter = Formatter.new do |severity, datetime, progname, message, io|
        if ENV.has_key?("FASTLANE_HIDE_TIMESTAMP")
          io << ""
        else
          io << "[#{datetime.to_s("%H:%M:%S")}]: "
        end

        io << message
      end
    end

    def message(message)
      @log.info(message.to_s)
    end

    def success(message)
      @log.info(message.to_s.colorize(:green))
    end

    def important(message)
      @log.warn(message.to_s.colorize(:yellow))
    end

    def error(message)
      @log.error(message.to_s.colorize(:red))
    end

    def verbose(message)
      @log.debug(message.to_s)
    end

    def crash!(message)
      @log.falal(message.to_s.colorize(:red))
    end
  end
end