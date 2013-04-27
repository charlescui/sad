$:.unshift(File.dirname __FILE__)
require 'helper'

class SadJob
	extend ::Sad::Worker
	
	def self.queue
		'MySadJob'
	end

	def self.perform(*args)
		raise RuntimeError, 'Error for test!!!!'
	end
end

EM.run {
	EM::PeriodicTimer.new(3){
		SadJob.enqueue('this is some args', {:hello => 'code'})	
	}
}