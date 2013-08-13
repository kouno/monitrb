require 'spec_helper'

describe MonitRB::Config do
  describe "::initialize" do
    subject { MonitRB::Config.new}

    it { should respond_to(:conditions) }
    it { should respond_to(:env) }
    it { should respond_to(:name) }
    it { should respond_to(:pid_file) }
    it { should respond_to(:pwd) }
    it { should respond_to(:shell_command) }
    it { should respond_to(:start) }
    it { should respond_to(:stop) }
    it { should respond_to(:type) }

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
end
