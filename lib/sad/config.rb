module Sad
	class Config
		class << self
			def namespace=(str)
				@_namespace = str
			end

			def namespace
				@_namespace || 'SadQueue'
			end

			def redis=(uri)
				@_redis_url = uri
			end

			def redis
				@_redis ||= EM::Hiredis.connect(@_redis_url)
			end
		end
	end
end