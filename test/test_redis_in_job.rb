$:.unshift(File.dirname __FILE__)
require 'helper'

EM.run {
	EM::PeriodicTimer.new(3){
		SadJob.enqueue('this is some args', {:hello => 'code'})	
	}
}