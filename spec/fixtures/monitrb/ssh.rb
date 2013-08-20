MonitRB::Config.define do |config|
  config.type       = :process
  config.name       = 'ssh'
  config.pid_file   = '/var/run/sshd.pid'

  config.start      = "/etc/init.d/sshd start"
  config.stop       = "/etc/init.d/sshd stop"

  config.conditions = [ 'if failed port 22 protocol ssh then restart',
                        'if 5 restarts within 5 cycles then timeout' ]
end
