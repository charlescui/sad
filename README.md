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


## 测试

启动一个队列

```sh
bundle exec rake sad:restart COUNT=1 QUEUE=MySadJob DIR=./tmp/pids
```

执行最简单的测试

```sh
bundle exec ruby ./test/test_sad.rb
```

执行异常任务测试,异常是指Klass.perform函数执行时出现异常，如果是异步任务，没办法知道异常，因为执行完perform后，代码运行环境已经脱离sad了，需要人工自己处理.

当Klass.perform出错时，会延时重试，重试三次后，如果还有错误，则放弃该任务.

```sh
bundle exec ruby ./test/test_perform_with_exception.rb
```

在异步模式的代码中，异常如果被抛给top level的运行时的话，则代码无法控制，所以有异常的时候一定要捕获到，写在类似errback的回调中，对于Sad的重试，自动重试只能保证perform执行没问题，如果在callback中出错，则需要用户手工将该任务重新enqueue来实现重试的机制。

## 任务配置

```ruby
SadJob.enqueue(1,2,3,4,5){|payload|
	# delay -> 当sad进程得到该任务时并不立即执行，而是延迟多干秒后执行
	payload.sad_args['delay'] = 5
}
```

## 日志logger

Sad.logger是个Logger的实例，通过如下方式来配置:

```ruby
Sad.logger = {:path => 'sad.production.log', :level => 2}
Sad.logger.error("Crashed!!!")
```

level的取值如下:

* DEBUG = 0
* INFO = 1
* WARN = 2
* ERROR = 3
* FATAL = 4
* UNKNOWN = 5

## 注意事项

* 本库使用的redis是em-hiredis，和redis库冲突，同一个项目不能同时引用

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

