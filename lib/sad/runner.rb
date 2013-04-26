require "daemons"

module Sad
	class Runner

		# === Example:
		#   options = {
		#     :app_name   => "my_app",
		#     :ARGV       => ['start', '-f', '--', 'param_for_myscript']
		#     :dir_mode   => :script,
		#     :dir        => 'pids',
		#     :multiple   => true,
		#     :ontop      => true,
		#     :mode       => :exec,
		#     :backtrace  => true,
		#     :monitor    => true
		#   }

		def self.exec(opts={})
			count = (ENV['COUNT'] && ENV['COUNT'].to_i)

			if count and count != 0
				count.times do |t|
					Daemons.run_proc("Sad-#{t+1}", opts) do
						EM.run{
							Sad::Server.run(ENV['QUEUE'])
						}
					end
				end
			end
		end
	end
end