module Sad
	class Config
		class << self
			def namespace=(str)
				@_namespace = str
			end

			def namespace
				@_namespace || 'SadQueue'
			end

			def redis=(opts={})
				opts = {
					:host => 'localhost', 
					:port => 6379,
					:db => 0
					}.update opts
				@_redis = EM::Protocols::Redis.connect :host => opts[:host], :port => opts[:port], :db => opts[:db]
			end

			def redis
				@_redis || (EM::Protocols::Redis.connect)
			end
		end
	end
end