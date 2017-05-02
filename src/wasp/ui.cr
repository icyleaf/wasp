require "colorize"
require "logger"

module Wasp
  class UI
    @log_level : Logger::Severity

    def self.instance
      @@instance ||= new
    end

    {% for method in [:message, :success, :important, :error, :verbose, :crash, :head] %}
      def self.{{method.id}}(message)
        instance.{{method.id}}(message)
      end
    {% end %}

    def initialize(@logger = Logger.new(STDOUT), @log_level = Logger::DEBUG)
      @logger.level = @log_level
      @logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
        if ENV.has_key?("WASP_HIDE_TIMESTAMP")
          io << ""
        else
          io << "#{severity} #{datetime.to_s("%Y-%m-%d %H:%M:%S")} "
        end

        io << message
      end
    end

    def head(message)
      text = "| #{message} |"
      line = "-" * text.size
      @logger.info(line)
      @logger.info(text)
      @logger.info(line)
    end

    def message(message)
      @logger.info(message.to_s)
    end

    def success(message)
      @logger.info(message.to_s.colorize(:green))
    end

    def important(message)
      @logger.warn(message.to_s.colorize(:yellow))
    end

    def error(message)
      @logger.error(message.to_s.colorize(:red))
    end

    def verbose(message)
      @logger.debug(message.to_s)
    end

    def crash(message, options = {} of Wasp::Any => Wasp::Any)
      raise Error.new(message, options)
    end
  end
end