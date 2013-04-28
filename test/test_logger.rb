$:.unshift(File.dirname __FILE__)
require 'helper'

puts Sad.logger.class
puts Sad.logger.inspect

EM.run{
	EM::PeriodicTimer.new(3){
		Sad.logger.error("this is a logger - #{Time.now}")
	}
}
