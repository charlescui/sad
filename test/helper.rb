require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sad'
require "redis"

$redis = Redis.new

class SadJob
	extend ::Sad::Worker
	
	def self.queue
		'MySadJob'
	end

	def self.redis
		$redis
	end

	def self.perform(*args)
		::Sad.logger.info("Enqueue with self.redis.")
	end
end
::Sad::Config.interval = 0.1