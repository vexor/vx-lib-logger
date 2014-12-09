require 'logger'
require File.expand_path("../logger/version", __FILE__)

module Vx ; module Lib
  module Logger

    autoload :Instance,         File.expand_path("../logger/instance",         __FILE__)
    autoload :JsonFormatter,    File.expand_path("../logger/json_formatter",   __FILE__)
    autoload :Instrumentations, File.expand_path("../logger/instrumentations", __FILE__)

    def self.get(io, options)
      Instance.new(io, options)
    end

  end
end ; end
