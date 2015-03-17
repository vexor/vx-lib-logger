require 'json'
require 'thread'
require 'socket'

module Vx ; module Lib ; module Logger

  class LogstashLogger < BaseLogger

    attr_reader :params, :logger, :logstash

    def initialize(params = {})
      @params = params

      @logger  = ::Logger.new(logstash_device)
      @logger.formatter = self.formatter
      @logger.progname  = self.progname
    end

    def close
      logstash_device.close
    end

    def wait
      logstash_device.wait
    end

    private

      def logstash_device
        Lib::Logger.logstash_device
      end

      def format_message(level, message, payload)
        LogstashFormatter.call(level, progname, message, payload)
      end

  end

end ; end ; end
