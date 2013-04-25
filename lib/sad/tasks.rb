namespace :sad do
	desc "start sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids"
	task :start do
		opts = {
			:dir => ENV['DIR'],
			:multiple => true,
			:log_output => true
			:backtrace  => true
		}
		Sad::Runner.start(opts)
	end
end