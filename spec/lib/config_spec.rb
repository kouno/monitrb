require 'spec_helper'

describe MonitRB::Config do
  describe "::initialize" do
    subject { MonitRB::Config.new }

    it { should respond_to(:conditions) }
    it { should respond_to(:env) }
    it { should respond_to(:name) }
    it { should respond_to(:path) }
    it { should respond_to(:pid_file) }
    it { should respond_to(:pwd) }
    it { should respond_to(:shell_command) }
    it { should respond_to(:start) }
    it { should respond_to(:stop) }
    it { should respond_to(:type) }
    it { should respond_to(:raw) }

    it "uses a hash for environment variables and auto format it" do
      subject.env = { rails_env: 'production', arg2: 'test' }
      expect(subject.env).to eq('RAILS_ENV=production ARG2=test')
    end

    it "uses an array of strings for conditions and auto format it" do
      subject.conditions = ['if 1 == 1', 'if helloworld']
      expect(subject.conditions).to eq("if 1 == 1\n  if helloworld")
    end
  end

  describe "::create" do
    it "creates a config object" do
      expect(MonitRB::Config.create).to be_a(MonitRB::Config)
    end

    it "is configurable through a block" do
      result = MonitRB::Config.create do |config|
        config.name = 'test'
      end

      expect(result.name).to eq('test')
    end
  end

  describe "::define" do
    it "adds a config to the stack" do
      MonitRB::Config.define do |config|
        config.type = :process
      end

      expect(MonitRB::Config.stack.size).to eq(1)
      expect(MonitRB::Config.stack.first.type).to eq(:process)
    end
  end

  describe "#wrap_script" do
    before(:each) do
      subject.start = '/etc/init/sshd start'
    end

    it "uses `cd` before the start script when pwd is defined" do
      subject.pwd = '/home/user/'
      expect(subject.wrap_script(subject.start)).to match %r{cd /home/user}
    end

    it "uses shell command if it's defined" do
      subject.shell_command = '/bin/sh -l -c'
      expect(subject.wrap_script(subject.start)).to match %r{/bin/sh -l -c '.*'}
    end

    it "uses env variables if they are defined" do
      subject.env = { fake_var: 'hello' }
      expect(subject.wrap_script(subject.start)).to match %r{FAKE_VAR=hello .*}
    end
  end

  describe "::raw" do
    it "creates a config object" do
      MonitRB::Config.raw <<-EOL
        check process test
          with pidfile /path/to/file
      EOL
      expect(MonitRB::Config.stack.count).to eq 1
    end
  end

  describe "::defaults" do
    before(:each) do
      MonitRB::Config.defaults(env: { rails_env: 'production' })
    end

    it "sets defaults on any configs" do
      expect(subject.env).to eq("RAILS_ENV=production")
    end
  end
end
