namespace :sad do
	desc "start sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids"
	task :start do
		opts = {
			:dir => ENV['DIR'],
			:multiple => true,
			:log_output => true,
			:backtrace  => true,
			:ARGV => ['start']
		}
		Sad::Runner.exec(opts)
	end

	desc "stop sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids"
	task :stop do
		opts = {
			:dir => ENV['DIR'],
			:multiple => true,
			:log_output => true,
			:backtrace  => true,
			:ARGV => ['stop']
		}
		Sad::Runner.exec(opts)
	end

	desc "restart sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids"
	task :restart do
		opts = {
			:dir => ENV['DIR'],
			:multiple => true,
			:log_output => true,
			:backtrace  => true,
			:ARGV => ['restart']
		}
		Sad::Runner.exec(opts)
	end
end
