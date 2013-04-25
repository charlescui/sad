module Sad
	class Payload
		attr_accessor :klass, :args

		def initialize(klass, args)
			@klass = klass
			@args = args
		end

		def encode
			{
				'klass' => @klass,
				'args' => @args
			}.to_json
		end

		def self.decode(json)
			h = JSON.parse(json)
			self.new(h['klass'], h['args'])
		end
	end
end