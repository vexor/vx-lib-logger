require 'logger'
require File.expand_path("../logger/version", __FILE__)

module Vx ; module Lib
  module Logger

    autoload :LogstashDevice,    File.expand_path("../logger/logstash_device",    __FILE__)
    autoload :StdoutFormatter,   File.expand_path("../logger/stdout_formatter",   __FILE__)
    autoload :LogstashFormatter, File.expand_path("../logger/logstash_formatter", __FILE__)
    autoload :BaseLogger,        File.expand_path("../logger/base_logger",        __FILE__)
    autoload :StdoutLogger,      File.expand_path("../logger/stdout_logger",      __FILE__)
    autoload :LogstashLogger,    File.expand_path("../logger/logstash_logger",    __FILE__)
    autoload :FluentBaseLogger,  File.expand_path("../logger/fluent_base_logger", __FILE__)
    autoload :FluentLogger,      File.expand_path("../logger/fluent_logger",      __FILE__)
    autoload :FluentFormatter,   File.expand_path("../logger/fluent_formatter",   __FILE__)

    module Rack
      autoload :HandleExceptions, File.expand_path("../logger/rack/handle_exceptions", __FILE__)
    end

    @@progname        = $0 && File.basename($0)
    @@default         = nil
    @@logstash_device = nil

    def self.progname=(value)
      @@progname = value
    end

    def self.progname
      @@progname
    end

    def self.logstash_device
      @@logstash_device ||= LogstashDevice.new
    end

    def self.get(target = nil)
      @@default ||= begin
        if logstash_device.enabled?
          LogstashLogger.new
        elsif ENV["FLUENT_HOST"]
          FluentLogger.new(host: ENV.fetch("FLUENT_HOST", "localhost"), port: ENV.fetch("FLUENT_PORT", 24224))
        else
          StdoutLogger.new(target || STDOUT)
        end
      end
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
