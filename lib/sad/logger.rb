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

			@logger = ::Logger.new(@opts[:path])
			@logger.level = @opts[:level]
		end

		def reopen
			@logger = ::Logger.new(@opts[:path])
			@logger.level = @opts[:level]
		end

		def method_missing(method_name, *args, &block)
			@logger.send(method_name, *args, &block)
		end
	end
end