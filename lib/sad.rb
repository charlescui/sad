$:.unshift File.join(File.dirname(__FILE__), '.')

require "active_support"
require "eventmachine"
require "em-hiredis"

module Sad
	autoload :Config, 'sad/config'
	autoload :Payload, 'sad/payload'
	autoload :Server, 'sad/server'
	autoload :Worker, 'sad/worker'
	autoload :Runner, 'sad/runner'
	autoload :Logger, 'sad/logger'

	class << self
		def logger=(opts)
			@_logger = ::Sad::Logger.new(opts)
		end

		def logger
			@_logger ||= ::Sad::Logger.new
		end
	end
end

EM.error_handler{
	::Sad.logger.fatal('exception hit eventmachine!!!')
}