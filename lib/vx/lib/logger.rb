require 'logger'
require File.expand_path("../logger/version", __FILE__)

module Vx ; module Lib
  module Logger

    autoload :Instance,         File.expand_path("../logger/instance",          __FILE__)
    autoload :JsonFormatter,    File.expand_path("../logger/json_formatter",    __FILE__)
    autoload :RawFormatter,     File.expand_path("../logger/raw_formatter",     __FILE__)

    module Rack
      autoload :HandleExceptions, File.expand_path("../logger/rack/handle_exceptions", __FILE__)
    end

    @@default = Instance.new(STDOUT)

    def self.get(io = nil, options = {})
      Instance.new(io, options)
    end

    def self.default
      @@default
    end

  end
end ; end
