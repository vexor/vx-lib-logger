require 'json'
require 'thread'
require 'socket'

module Vx ; module Lib ; module Logger

  class StdoutLogger < BaseLogger

    attr_reader :params, :logger, :logstash

    def initialize(io, params = {})
      @params = params

      @logger           = ::Logger.new(io, 7, 50_000_000)
      @logger.formatter = self.formatter
      @logger.progname  = self.progname
    end

    private

      def format_message(level, message, payload)
        StdoutFormatter.call(level, message, payload)
      end

  end

end ; end ; end
