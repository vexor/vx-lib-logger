require 'oj'

module Vx ; module Lib ; module Logger

  JsonFormatter = Struct.new(:parent) do

    def call(_, _, _, msg)
      ::Oj.dump(msg, mode: :compat) + "\n"
    end

=begin
    def safe_value(value, options = {})
      new_value = case value.class.to_s
                  when "String", "Fixnum", "Float"
                    value
                  when "Symbol", "BigDecimal"
                    value.to_s
                  when "Array"
                    value = value.map(&:to_s)
                    options[:join_arrays] ? value.join("\n") : value
                  when 'NilClass'
                    nil
                  else
                    value.inspect
                  end
      if new_value.is_a?(String)
        new_value.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
      else
        new_value
      end
    end

    def make_safe_hash(msg, options = {})
      msg.inject({}) do |acc, pair|
        msg_key, msg_value = pair

        if msg_key == :fields
          acc[msg_key] = make_safe_hash(msg_value, join_arrays: true)
        else
          acc[msg_key] = safe_value(msg_value, options)
        end
        acc
      end
    end
  end
=end
  end

end ; end ; end
