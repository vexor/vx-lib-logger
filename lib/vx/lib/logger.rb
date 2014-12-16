require 'logger'
require File.expand_path("../logger/version", __FILE__)

module Vx ; module Lib
  module Logger

    autoload :Instance,         File.expand_path("../logger/instance",          __FILE__)
    autoload :JsonFormatter,    File.expand_path("../logger/json_formatter",    __FILE__)
    autoload :Instrumentations, File.expand_path("../logger/instrumentations",  __FILE__)
    autoload :HandleExceptions, File.expand_path("../logger/handle_exceptions", __FILE__)

    @@default = Instance.new(STDOUT)

    def self.get(io, options)
      Instance.new(io, options)
    end

    def default
      @@default
    end

  end
end ; end
