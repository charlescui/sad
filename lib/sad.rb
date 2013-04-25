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
end