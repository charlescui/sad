require "json"

module Sad
	class Payload
		attr_accessor :klass, :args, :sad_args

		def initialize(klass, args = [], sad_args = {})
			@klass = klass
			@args = args
			@sad_args = {
				'retry' => 0,
				'delay' => 0
			}.update(sad_args)
		end

		def encode
			{
				'klass' => @klass,
				'args' => @args,
				'sad_args' => @sad_args
			}.to_json
		end

		# 执行任务
		# 当执行任务的perform出错时
		# 重试1至::Sad::Config.max_retry次
		# 每次重试时，延迟重试次数*::Sad::Config.interval的时长后，再enqueue
		def perform
			begin
				@klass.constantize.send :perform, *@args
			rescue Exception => e
				if self.sad_args['retry'] and (self.sad_args['retry'].to_i < ::Sad::Config.max_retry)
					self.sad_args['retry'] = self.sad_args['retry'].to_i + 1
					self.sad_args['delay'] = ::Sad::Config.interval * self.sad_args['retry']
					self.enqueue
				else
					::Sad.logger.error "Payload perform error for #{self.sad_args['retry']} retrys:\n#{self.inspect}\nException:\n#{e.inspect}\nBacktrace:\n#{e.backtrace.inspect}"
				end
			end
		end

		def enqueue(&blk)
			::Sad::Config.redis.rpush(self.sad_args['queue'], self.encode) do |value|
				blk.call(value) if blk
			end
		end

		def self.decode(json)
			h = JSON.parse(json)
			if h['sad_args'] or h['sad_args'] != ''
				self.new(h['klass'], h['args'], h['sad_args'])
			else
				self.new(h['klass'], h['args'])
			end
		end
	end
end