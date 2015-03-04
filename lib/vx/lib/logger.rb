require 'logger'
require File.expand_path("../logger/version", __FILE__)

module Vx ; module Lib
  module Logger

    autoload :Instance,         File.expand_path("../logger/instance",          __FILE__)
    autoload :StdoutFormatter,  File.expand_path("../logger/stdout_formatter",  __FILE__)
    autoload :JournalFormatter, File.expand_path("../logger/journal_formatter", __FILE__)
    autoload :Logstash,         File.expand_path("../logger/logstash",          __FILE__)
    autoload :Sanitizer,        File.expand_path("../logger/sanitizer",         __FILE__)

    module Rack
      autoload :HandleExceptions, File.expand_path("../logger/rack/handle_exceptions", __FILE__)
    end

    @@logstash = Logstash.new
    @@default  = Instance.new(STDOUT, logstash: @@logstash)

    def self.get(io = nil, options = {})
      Instance.new(io || STDOUT, options.merge(logstash: @@logstash))
    end

    def self.default
      @@default
    end

    def self.install_handle_exceptions_middleware
      if defined? Rails
        ::Rails.application.config.middleware.insert 0, Vx::Lib::Logger::Rack::HandleExceptions

        if ::Rails.env.production?
          ::Rails.application.config.middleware.delete ::ActionDispatch::DebugExceptions
        end
      end
    end

  end
end ; end
