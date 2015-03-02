require 'oj'

module Vx ; module Lib ; module Logger

  module JsonFormatter

    def self.call(message, payload)
      payload = ::Oj.dump(payload, mode: :compat)
      "#{message} :--: #{payload}"
    end

  end

end ; end ; end
