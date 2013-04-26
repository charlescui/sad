# sad

:sob: 悲剧，居然找不到好用的基于Eventmachine的后台任务，只好自己写了。

## 快速入门

测试类的定义

```ruby
class SadJob
	extend ::Sad::Worker
	
	def self.queue
		'MySadJob'
	end

	def self.perform(*args)
		puts "I'm in sad job perform method."
		puts args
	end
end
```

在一个IRB/PRY中执行

```ruby
EM.run{
	EM::PeriodicTimer.new(3){
		Imdb::SadJob.enqueue('hello',{:x=>['hi',123], :y => {}})
	}
}
```

在另外一个IRB/PRY中执行

```ruby
EM.run{
	Sad::Server.run('MySadJob')
}
```

两个运行环境都要有SadJob这个测试类的定义存在

--------

## 在项目中使用

在Gemfile中添加:

```ruby
gem 'sad', :git => 'git@github.com:charlescui/sad.git'
```

在Rakefile中添加:

```ruby
require "sad/tasks"
```

配置redis:

```ruby
Sad::Config.redis = "redis://:secretpassword@example.com:9000/4"
Sad::Config.namespace = 'MyBackgroundJobQueue'
```

查看是否有sad的rake任务:

		saimatoMacBook-Pro:rca.imdb cuizheng$ bundle exec rake -T
		rake sad:restart                # restart sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids
		rake sad:start                  # start sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids
		rake sad:stop                   # stop sad with args - COUNT=4 QUEUE=sosad DIR=./tmp/pids

启动:`bundle exec rake sad:start COUNT=2 QUEUE=sosad DIR=./tmp/pids`

检查下目录是否有pid文件

		saimatoMacBook-Pro:rca.imdb cuizheng$ ll tmp/pids/
		total 40
		-rw-r--r--  1 cuizheng  staff  1315  4 26 15:36 Sad-1.output
		-rw-r--r--  1 cuizheng  staff     5  4 26 15:32 Sad-10.pid
		-rw-r--r--  1 cuizheng  staff  1138  4 26 15:36 Sad-2.output
		-rw-r--r--  1 cuizheng  staff     5  4 26 15:32 Sad-20.pid

查看下进程

		saimatoMacBook-Pro:rca.imdb cuizheng$ !ps
		ps ax|grep Sad
		 6178   ??  R      0:02.58 Sad-1      
		 6181   ??  S      0:02.61 Sad-2      
		 6522 s002  R+     0:00.00 grep Sad

## Contributing to sad
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 崔峥. See LICENSE.txt for
further details.

