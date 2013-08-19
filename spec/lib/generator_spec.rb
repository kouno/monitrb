require 'spec_helper'

describe MonitRB::Generator do
  subject { MonitRB::Generator }

  let(:name)          { 'resque' }
  let(:type)          { :process }
  let(:pid_file)      { '/path/to/pidfile' }
  let(:shell_command) { '/bin/sh -l -c' }
  let(:pwd)           { '/srv/APP_NAME/current' }
  let(:start)         { "nohup bundle exec rake environment resque:work >> log/resque_worker_QUEUE.log 2>&1" }
  let(:stop)          { "kill -9 $(cat /path/to/pidfile) && rm -f /path/to/pidfile; exit 0;" }
  let(:conditions)    { [ "if totalmem > 100.0 MB for 5 cycles then restart " ] }
  let(:env)           { { home: '/home/user',
                          rails_env: 'production',
                          queue: 'queue_name',
                          verbose: '1',
                          pidfile: '/path/to/pidfile' } }

  let(:expected_conf) { File.read(fixtures_path('monit', 'resque.monitrc')) }

  before(:each) do
    load fixtures_path('monitrb', 'resque.rb')
  end

  describe "#parse" do
    it "produces a monit configuration" do
      expect(subject.parse(MonitRB::Config.stack).to_s).to globally_match(expected_conf)
    end
  end

  describe "#write" do
    before(:each) do
      FileUtils.rm(filepath) if File.exists?(filepath)
      subject.parse(MonitRB::Config.stack).write_to(filepath)
    end

    after(:each) do
      FileUtils.rm(filepath) if File.exists?(filepath)
    end

    let(:filepath) { File.join('tmp', 'monit.conf') }

    it "writes file to specified folder" do
      expect(File.exists?(filepath)).to be_true
      expect(File.read(filepath)).to globally_match(expected_conf)
    end
  end
end
