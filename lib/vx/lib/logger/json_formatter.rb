require 'json'

module Vx ; module Lib ; module Logger

  JsonFormatter = Struct.new(:parent) do

    def call(_, _, _, msg)
      ::JSON.dump(msg) + "\n"
    end

  end

end ; end ; end
