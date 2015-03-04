require 'json'
require 'thread'
require 'socket'

module Vx ; module Lib ; module Logger

  class Instance

    attr_reader :params, :logger, :logstash

    def initialize(io, params = {})
      @logstash = params.delete(:logstash)
      @params   = params

      @progname = @params.delete(:progname)

      @progname ||= begin
        pname = $PROGRAM_NAME
        pname && File.basename(pname)
      end

      @formatter = ->(_,_,_,m) { m }

      @logger           = ::Logger.new(io, 7, 50_000_000)
      @logger.formatter = @formatter
      @logger.progname  = @progname

      @logstash_logger  = ::Logger.new(logstash)
      @logstash_logger.formatter = @formatter
      @logstash_logger.progname  = @progname
    end

    [:fatal, :warn, :debug, :error, :info].each do |m|
      define_method m do |*args|
        process_message(m, *args)
      end

      define_method :"#{m}?" do
        @logger.public_send :"#{m}?"
      end
    end

    def level
      @logger.level
    end

    def level=(new_val)
      @logger.level = new_val
    end

    def progname=(new_val)
      @progname = new_val
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
          ex = options.delete(:exception)
          options.merge!(
            exception:   [ex.class.to_s, ex.message].join(" - "),
            backtrace:   (ex.backtrace || []).map(&:to_s).join("\n"),
          )
        end

        body = {
          thread_id:  ::Thread.current.object_id,
        }

        if options && options != {}

          duration = options.delete(:duration)
          if duration && duration.respond_to?(:to_f)
            body.merge!(duration: duration.to_f)
          end

          body.merge!(
            fields: Sanitizer.hash(options)
          )
        end


        @logger.public_send level, format_stdout(level, message, body)

        if logstash.enabled?
          @logstash_logger.public_send level, format_journal(level, message, body)
        end
      end

      def format_stdout(level, message, payload)
        StdoutFormatter.call(level, message, payload)
      end

      def format_journal(level, message, payload)
        JournalFormatter.call(level, @progname, message, payload)

      end

  end

end ; end ; end
