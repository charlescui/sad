module Sad
	class Config
		class << self
			def namespace=(str)
				@_namespace = str
			end

			def namespace
				@_namespace || 'SadQueue'
			end

			def default_rds_opts(inopts={})
				opts = {
					:host => 'localhost', 
					:port => 6379,
					:db => 0
					}.update inopts.dup
				if opts[:password]
					url = "redis://#{opts[:password]}@#{opts[:host]}:#{opts[:port]}/#{opts[:db]}"
				else
					url = "redis://#{opts[:host]}:#{opts[:port]}/#{opts[:db]}"
				end
			end

			def redis=(opts={})
				@_redis = EM::Hiredis.connect default_rds_opts(opts)
			end

			def redis
				@_redis || EM::Hiredis.connect
			end
		end
	end
end