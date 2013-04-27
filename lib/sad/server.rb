module Sad
	class Server
		class << self
			def run(queue)
				@_shutdown = false
				register_signal
				fetch(Sad::Config.queue(queue))
			end

			def fetch(queue)
				request = ::Sad::Config.redis.blpop(queue, 60)
				request.callback{|_, data|
					if data
						logger.info '-'*15 + data.inspect + '-'*15
						payload = Payload.decode(data)
						payload_call(payload)
					end
					fetch_with_interval(queue)
				}
				request.errback{
					logger.error "error with redis request.\n#{request.inspect}"
					fetch_with_interval(queue)
				}
			end

			def fetch_with_interval(queue)
				EM.add_timer(::Sad::Config.interval){
					fetch(queue) unless shutdown?
				}
			end

			def payload_call(payload)
				# 如果该任务有延时执行要求，
				# 则在定时器执行时将其延时的key删掉，
				# 再重新入队
				if payload.sad_args['delay'] and payload.sad_args['delay'] != '' and payload.sad_args['delay'] != 0
					EM.add_timer(payload.sad_args['delay'].to_i){
						payload.sad_args.delete('delay')
						payload.enqueue
					}
				else
					payload.perform
				end
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
				EM.stop
			end
		end
	end
end