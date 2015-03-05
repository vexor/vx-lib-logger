require 'oj'

module Vx ; module Lib ; module Logger

  module StdoutFormatter

    def self.call(level, message, payload)
      if payload[:fields] && payload[:fields] != {}
        payload = " " + ::Oj.dump(payload[:fields], mode: :compat)
      else
        payload = ""
      end

      if level.length < 5
        level = "#{level} "
      end

      "[#{level}] #{message}#{payload}\n"
    end

  end

end ; end ; end
