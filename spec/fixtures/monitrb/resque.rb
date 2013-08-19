MonitRB::Config.define do |config|
  config.type          = :process
  config.name          = 'resque'
  config.pid_file      = '/path/to/pidfile'

  config.env           = { home: '/home/user',
                           rails_env: 'production',
                           queue: 'queue_name',
                           verbose: '1',
                           pidfile: '/path/to/pidfile' }

  config.shell_command = '/bin/sh -l -c'
  config.pwd           = '/srv/APP_NAME/current'

  config.start         = "nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1"
  config.stop          = "kill -9 $(cat /path/to/pidfile) && rm -f /path/to/pidfile; exit 0;"
  config.conditions    = [ 'if totalmem > 100.0 MB for 5 cycles then restart' ]
end
