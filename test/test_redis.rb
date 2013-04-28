$:.unshift(File.dirname __FILE__)
require 'helper'

EM.run{
	::Sad::Config.redis.info do |info|
		puts info
		EM.stop
	end
}
