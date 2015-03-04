module Vx ; module Lib ; module Logger

  module Sanitizer

    def self.hash(payload)
      payload = {} unless payload.is_a?(Hash)

      payload.keys.each do |key_name|
        value = payload[key_name]
        unless value.is_a?(String)
          payload[key_name] = value.to_s
        end
      end

      payload
    end

  end

end ; end ; end
