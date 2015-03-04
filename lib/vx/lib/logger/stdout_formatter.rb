require 'oj'

module Vx ; module Lib ; module Logger

  module StdoutFormatter

    def self.call(level, message, payload)
      payload = ::Oj.dump(payload, mode: :compat)
      "[#{level}] #{message} :--: #{payload}\n"
    end

  end

end ; end ; end
