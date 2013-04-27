module Sad
	module Worker
		def queue_name
			name = if self.respond_to?(:queue)
				self.send :queue
			else
				nil
			end
			Sad::Config.queue(name)
		end

		def enqueue(*args)
			payload = ::Sad::Payload.new(self.to_s, args)
			payload.sad_args['queue'] = queue_name
			yield payload if block_given?
			payload.enqueue
		end
	end
end