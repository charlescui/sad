module Sad
	class Procline
		class << self
			def basename
				@_basename ||= $0
			end

			def set(str)
				$0 = "#{basename}:#{str}"
			end
		end
	end
end