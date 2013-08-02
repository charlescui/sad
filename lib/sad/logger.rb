require "logger"

module Sad
	class Logger
=begin
    # Low-level information, mostly for developers
    DEBUG = 0
    # generic, useful information about system operation
    INFO = 1
    # a warning
    WARN = 2
    # a handleable error condition
    ERROR = 3
    # an unhandleable error that results in a program crash
    FATAL = 4
    # an unknown message that should always be logged
    UNKNOWN = 5
=end
		def initialize(opts={})
			@opts = {
				:path => STDOUT,
				:level => 1
			}.update opts.dup
			init_log
		end

		def reopen
			@logger = init_log
			reset_loggers(@logger)
		end

		def init_log
			logger = ::Logger.new(@opts[:path])
			logger.level = @opts[:level]
			logger.formatter = ::Logger::Formatter.new
			logger
		end

		def reset_loggers(logger)
			if defined?(ActiveRecord)
				ActiveRecord::Base.logger = logger
			end

			if defined?(Rails)
				Rails.logger = logger
			end

			if defined?(Mongoid)
				Mongoid.logger = logger
			end

			if defined?(Paperclip)
				Paperclip.logger = logger
			end

		end

		def method_missing(method_name, *args, &block)
			@logger.send(method_name, *args, &block)
		end
	end
end