require 'helper'

class SadJob
	extend ::Sad::Worker
	
	def self.queue
		'MySadJob'
	end

	def self.perform(*args)
		puts "I'm in sad job perform method."
		puts args
	end
end

EM::PeriodicTimer.new(3){
	SadJob.enqueue('this is some args', {:hello => 'code'})	
}