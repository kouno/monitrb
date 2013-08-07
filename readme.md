MonitRB
=======

MonitRB tries to fill in the gap between your Rails app configuration and your server configuration by providing a
wrapper around Monit, storing your configuration files within your project.

Usage
=====

Start with a simple configuration for your master node:

```ruby
MonitRB.create do |config|
  config.process       = 'resque'
  config.pidfile       = '/path/to/pidfile'

  config.env           = '/usr/bin/env HOME=/home/user PATH=/usr/local/bin:/usr/local/ruby/bin:/usr/bin:/bin:$PATH RAILS_ENV=production QUEUE=queue_name VERBOSE=1 PIDFILE=tmp/pids/resque_worker_QUEUE.pid'
  config.shell_command = '/bin/sh -l -c'
  config.pwd           = '/srv/APP_NAME/current'

  config.start         = "nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1"
  config.stop          = "kill -9 $(cat tmp/pids/resque_worker_QUEUE.pid) && rm -f tmp/pids/resque_worker_QUEUE.pid; exit 0;"
end
```

$ monitrb generate config --path=path/to/monitrb/file
$ monitrb list
