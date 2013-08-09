require 'spec_helper'

describe MonitRB::Generator do
  subject { MonitRB::Generator.new }

  let(:name) { 'resque' }
  let(:type) { :process }
  let(:pid_file) { '/path/to/pidfile' }
  let(:shell_command) { '/bin/sh -l -c' }
  let(:pwd) { '/srv/APP_NAME/current' }

  let(:start) { "nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1" }
  let(:stop) { "kill -9 $(cat /path/to/pidfile) && rm -f /path/to/pidfile; exit 0;" }

  let(:env) { { home: '/home/user',
                 rails_env: 'production',
                 queue: 'queue_name',
                 verbose: '1',
                 pidfile: '/path/to/pidfile' } }

  it "produces a monit configuration" do
    monit_config = MonitRB::Config.create do |config|
      config.type          = type
      config.name          = name
      config.pid_file       = pid_file

      config.env           = env

      config.shell_command = shell_command
      config.pwd           = pwd

      config.start         = start
      config.stop          = stop
    end

    expected = <<-MONIT.gsub(/^ */, '')
    check process resque
      with pidfile /path/to/pidfile
      start program = "HOME=/home/user RAILS_ENV=production QUEUE=queue_name VERBOSE=1 PIDFILE=/path/to/pidfile /bin/sh -l -c 'cd /srv/APP_NAME/current && nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1'"
      stop program = "HOME=/home/user RAILS_ENV=production QUEUE=queue_name VERBOSE=1 PIDFILE=/path/to/pidfile /bin/sh -l -c 'cd /srv/APP_NAME/current && kill -9 $(cat /path/to/pidfile) && rm -f /path/to/pidfile; exit 0;'"
    MONIT

    expect(subject.run(monit_config).gsub(/^ */, '')).to eq(expected)
  end
end
