module Sad
	class Config
		class << self
			def namespace=(str)
				@_namespace = str
			end

			def namespace
				@_namespace || 'SadQueue'
			end

			def queue(q)
				[Sad::Config.namespace, q].join ':'
			end

			def redis=(uri)
				@_redis_url = uri
			end

			def redis
				@_redis ||= EM::Hiredis.connect(@_redis_url)
			end

			def interval=(int)
				@_interval = int.to_i
			end

			def interval
				@_interval ||= 3
			end

			def max_retry=(int)
				@_max_retry = int.to_i
			end

			def max_retry
				@_max_retry ||= 3
			end
		end
	end
end