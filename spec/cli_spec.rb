require 'spec_helper'

describe MonitRB::CLI do
  before(:each) do
    config = <<-CONFIG
      MonitRB::Config.define do |config|
        config.type          = :process
        config.name          = 'resque'
        config.pid_file       = '/path/to/pidfile'

        config.env           = { home: '/home/user',
                                 rails_env: 'production',
                                 queue: 'queue_name',
                                 verbose: '1',
                                 pidfile: 'tmp/pids/resque_worker_QUEUE.pid' }

        config.shell_command = '/bin/sh -l -c'
        config.pwd           = '/srv/APP_NAME/current'

        config.start         = "nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1"
        config.stop          = "kill -9 $(cat tmp/pids/resque_worker_QUEUE.pid) && rm -f tmp/pids/resque_worker_QUEUE.pid; exit 0;"
      end
    CONFIG

    File.open(filepath, 'w') { |f| f.write(config) }
  end

  after(:each) do
    File.delete(filepath) if File.exists?(filepath)
  end

  let(:filepath) { File.join(Dir.getwd, 'tmp', 'input.rb') }

  describe "::build" do
    it "creates a monit configuration file" do
      MonitRB::CLI.start %w{ build --path=tmp/input.rb --output=tmp/output.monit }
      expect(File.exists?(File.join('tmp/output.monit'))).to be_true
    end
  end
end
