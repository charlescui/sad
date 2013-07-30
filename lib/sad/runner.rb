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
					Daemons.run_proc("Sad-#{Sad::Config.queue(ENV['QUEUE'])}-#{t+1}", opts) do
						self.require_libs
						self.show_info
						EM.run{
							Sad.logger.reopen
							Sad::Server.run(ENV['QUEUE'])
						}
					end
				end
			end
		end

		def self.show_info
			p "Interval:#{::Sad::Config.interval}"
		end

		def self.require_libs
			if ENV['LIBS']
				p "Require libs:"
				ENV['LIBS'].split(',').each do |f|
					file = File.join(ENV['SAD_OLD_ROOT'], f)
					p("===LIBS: #{file}")
					require file
				end
			end
		end
	end
end