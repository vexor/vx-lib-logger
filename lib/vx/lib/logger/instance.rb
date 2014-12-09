require 'json'
require 'thread'

module Vx ; module Lib ; module Logger

  class Instance

    attr_reader :params, :logger

    def initialize(io, params = {})
      @params           = params
      @logger           = ::Logger.new(io, 7, 50_000_000)
      @logger.formatter = get_formatter(params[:format])
    end

    [:fatal, :warn, :debug, :error, :info, :notice].each do |m|
      define_method m do |*args|
        process_message(m, *args)
      end
    end

    def get_formatter(name)
      case name
      when :json
        JsonFormatter.new
      else
        JsonFormatter.new
      end
    end

    def handle(message, options = {})
      be = Time.now.to_f
      re = nil
      ex = nil

      begin
        re = yield options
      rescue Exception => e
        ex = e
      end

      en = Time.now.to_f
      options.merge!(duration: (en - be))

      if ex
        error message, options.merge!(exception: ex) if ex
        raise ex
      else
        info message, options
      end

      re
    end

    private

      def process_message(level, message, options = {})

        if options[:exception] && options[:exception].is_a?(Exception)
          ex = options[:exception]
          options.merge!(
            exception:   [ex.class.to_s, ex.message],
            backtrace:   (ex.backtrace || []).map(&:to_s).join("\n"),
          )
        end

        options.merge!(
          message:    message,
          thread_id:  ::Thread.current.object_id,
          process_id: ::Process.pid,
          progname:   (params[:progname] || :ruby),
          level:      level,
        )

        @logger.public_send level, options
      end

  end

end ; end ; end
