module Vx ; module Lib ; module Logger

  RawFormatter = Struct.new(:parent) do

    def call(severity, datetime, progname, msg)
      "[#{severity}] #{msg.to_s}\n"
    end
  end

end ; end ; end
