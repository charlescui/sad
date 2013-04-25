module Sad
	module Worker
		def queue_name
			name = if self.respond_to?(:queue)
				self.send :queue
			else
				nil
			end
			[Sad::Config.namespace, name].join ':'
		end

		def enqueue(*args)
			payload = ::Sad::Payload.new(self.to_s, args)
			::Sad::Config.redis.rpush(queue_name, payload.encode)
		end
	end
end