module Sad
	class Server
		class << self
			def run(queue)
				@_shutdown = false
				register_signal
				fetch([Sad::Config.namespace, queue].join ':')
			end

			def fetch(queue)
				::Sad::Config.redis.blpop(queue, 60){|_, data|
					if data
						STDOUT.puts '-'*15 + data.inspect + '-'*15
						payload = Payload.decode(data)
						EM.defer{perform(payload.klass, payload.args)}
					end
					fetch(queue) unless shutdown?
				}
			end

			def perform(klass, args)
				klass.constantize.send :perform, args
			end

			def register_signal
				trap('TERM') { shutdown!  }
      			trap('INT')  { shutdown!  }
      			trap('QUIT') { shutdown   }
			end

			def shutdown!
				EM.stop
				exit(0)
			end

			def shutdown?
				@_shutdown
			end

			def shutdown
				@_shutdown = true
			end
		end
	end
end