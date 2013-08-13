require 'spec_helper'

describe MonitRB::Generator do
  subject { MonitRB::Generator.new }

  let(:name)          { 'resque' }
  let(:type)          { :process }
  let(:pid_file)      { '/path/to/pidfile' }
  let(:shell_command) { '/bin/sh -l -c' }
  let(:pwd)           { '/srv/APP_NAME/current' }

  let(:start)         { "nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1" }
  let(:stop)          { "kill -9 $(cat /path/to/pidfile) && rm -f /path/to/pidfile; exit 0;" }
  let(:conditions)    { [ "if totalmem > 100.0 MB for 5 cycles then restart " ] }

  let(:env) { { home: '/home/user',
                rails_env: 'production',
                queue: 'queue_name',
                verbose: '1',
                pidfile: '/path/to/pidfile' } }

  before(:each) do
    @monit_config = MonitRB::Config.create do |config|
      config.type          = type
      config.name          = name
      config.pid_file      = pid_file

      config.env           = env

      config.shell_command = shell_command
      config.pwd           = pwd

      config.start         = start
      config.stop          = stop
      config.conditions    = conditions
    end

    @expected_conf = <<-MONIT
        check process resque
          with pidfile /path/to/pidfile
          start program = "HOME=/home/user RAILS_ENV=production QUEUE=queue_name VERBOSE=1 PIDFILE=/path/to/pidfile
            /bin/sh -l -c 'cd /srv/APP_NAME/current && nohup bundle exec rake environment resque:work
            >> log/resque_worker_QUEUE.log 2>&1'"
          stop program = "HOME=/home/user RAILS_ENV=production QUEUE=queue_name VERBOSE=1 PIDFILE=/path/to/pidfile
            /bin/sh -l -c 'cd /srv/APP_NAME/current && kill -9 $(cat /path/to/pidfile) && rm -f /path/to/pidfile;
            exit 0;'"
          if totalmem > 100.0 MB for 5 cycles then restart
      MONIT
  end

  describe "#parse" do
    it "produces a monit configuration" do
      expect(subject.parse(@monit_config).to_s).to globally_match(@expected_conf)
    end
  end

  describe "#write" do
    before(:each) do
      FileUtils.rm(filepath) if File.exists?(filepath)
      subject.parse(@monit_config).write_to(filepath)
    end

    after(:each) do
      FileUtils.rm(filepath) if File.exists?(filepath)
    end

    let(:filepath) { File.join('tmp', 'monit.conf') }

    it "writes file to specified folder" do
      expect(File.exists?(filepath)).to be_true
      expect(File.read(filepath)).to globally_match(@expected_conf)
    end
  end
end
