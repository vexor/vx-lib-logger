module Vx ; module Lib ; module Logger
  class FluentBaseLogger < ::Fluent::Logger::LevelFluentLogger

    def initialize(tag_prefix = nil, *args)
      super
      @default_formatter = proc do |severity, datetime, progname, message|
        default_formatter_call(severity, datetime, progname, message)
      end
    end

    def add(severity, message = nil, progname = nil, &block)
      severity ||= UNKNOWN
      if severity < @level
        return true
      end
      progname ||= @progname
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end
      progname ||= Lib::Logger.progname
      map = format_message(format_severity(severity), Time.now, progname, message)
      puts map.inspect
      @fluent_logger.post(format_severity(severity).downcase, map)
      true
    end

    def default_formatter_call(severity, datetime, progname, message)
      map = case message
      when Hash
        message
      else
        {message: message}
      end

      map.merge(
        datetime: datetime
      )
    end
  end
end; end; end
