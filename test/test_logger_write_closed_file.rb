$:.unshift(File.dirname __FILE__)
require 'helper'
require "logger"
require "daemons"

log = Logger.new(File.join(File.dirname(__FILE__), 'info.log'))
log.level = Logger::INFO
opts = {
	:dir => ENV['DIR'] || File.dirname(__FILE__),
	:multiple => true,
	:log_output => true
}
Daemons.run_proc("hello", opts){
	STDERR.puts log.inspect
	100000.times do |t|
		log.error "#{Time.now} logger!!!!"
	end
}

__END__

saimatoMacBook-Pro:sad cuizheng$ head -n100 test/hello.output 
hello: process with pid 3392 started.
#<Logger:0x007fb44a7b7658 @progname=nil, @level=1, @default_formatter=#<Logger::Formatter:0x007fb44a7b7608 @datetime_format=nil>, @formatter=nil, @logdev=#<Logger::LogDevice:0x007fb44a7b75b8 @shift_size=1048576, @shift_age=0, @filename="test/info.log", @dev=#<File:test/info.log (closed)>, @mutex=#<Logger::LogDevice::LogDeviceMutex:0x007fb44a7b7590 @mon_owner=nil, @mon_count=0, @mon_mutex=#<Mutex:0x007fb44a7b7540>>>>
log writing failed. closed stream
log writing failed. closed stream
log writing failed. closed stream