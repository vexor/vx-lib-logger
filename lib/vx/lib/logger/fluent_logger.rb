require 'fluent-logger'

module Vx ; module Lib ; module Logger
    class FluentLogger < BaseLogger
      attr_reader :logger

      def initialize(params = {})
        @logger = FluentBaseLogger.new('fluent', params)
      end

      def close
        logger.close
      end

      def wait
        # nothing
      end

      private

      def format_message(level, message, payload)
        FluentFormatter.call(level, self.progname, message, payload)
      end

    end
end; end; end
