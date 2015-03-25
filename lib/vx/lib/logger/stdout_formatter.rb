require 'oj'

module Vx ; module Lib ; module Logger

  module StdoutFormatter

    def self.call(level, message, payload)
      if payload[:fields] && payload[:fields] != {}
        payload_str = " " + ::Oj.dump(payload[:fields], mode: :compat)
      else
        payload_str = ""
      end

      if level.length < 5
        level = "#{level} "
      end

      if d = payload.delete(:duration)
        d = "%.4f" % d
        payload_str = "#{payload_str} (#{d}s)"
      end

      "[#{level}] #{message}#{payload_str}\n"
    end

  end

end ; end ; end
