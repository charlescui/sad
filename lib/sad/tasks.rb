namespace :sad do
	desc "start sad with args - COUNT=4 QUEUE=sosad"
	task :start do
		opts = {
			:dir => ENV['DIR'],
			:multiple => true,
			:mode => :exec,
			:backtrace  => true
		}
		Sad::Runner.start(opts)
	end
end