module Vx ; module Lib ; module Logger

  class BaseLogger

    def formatter
      @formatter ||= ->(_,_,_,m) { m }
    end

    def formatter=(val) ; end

    def progname
      Lib::Logger.progname
    end

    def progname=(val)
      # disable
    end

    def level
      @logger.level
    end

    def level=(new_val)
      @logger.level = new_val
    end

    [:fatal, :warn, :debug, :error, :info].each do |m|
      define_method m do |*args, &block|
        process_message(m, *args, &block)
      end

      define_method :"#{m}?" do
        @logger.public_send :"#{m}?"
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

      def process_message(level, message = nil, fields = {})
        if block_given?
          message = yield
        end

        if fields[:exception] && fields[:exception].is_a?(Exception)
          ex = fields.delete(:exception)
          fields.merge!(
            exception:   [ex.class.to_s, ex.message].join(" - "),
            backtrace:   (ex.backtrace || []).map(&:to_s).join("\n"),
          )
        end

        payload = {
          thread_id: ::Thread.current.object_id,
        }

        if fields && fields != {}

          duration = fields.delete(:duration)
          if duration && duration.respond_to?(:to_f)
            payload.merge!(duration: duration.to_f)
          end

          payload.merge!(
            fields: sanitize_hash(fields)
          )
        end

        @logger.public_send level, format_message(level, message.to_s, payload)
      end

      def sanitize_hash(payload)
        payload = {} unless payload.is_a?(Hash)

        payload.keys.each do |key_name|
          value = payload[key_name]
          unless value.is_a?(String)
            payload[key_name] = value.to_s
          end
        end

        payload
      end

      def format_message(level, message, payload)
        raise NotImplementedError
      end

  end

end ; end ; end
