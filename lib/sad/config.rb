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
				@_redis = EM::Hiredis.connect uri
			end

			def redis
				@_redis ||= EM::Hiredis.connect
			end
		end
	end
end