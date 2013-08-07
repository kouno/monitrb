require 'spec_helper'

describe MonitRB::Config do
  describe "::initialize" do
    subject { MonitRB::Config.create }

    it { should respond_to(:process) }
    it { should respond_to(:pid_file) }
    it { should respond_to(:shell_command) }
    it { should respond_to(:env) }
    it { should respond_to(:pwd) }
    it { should respond_to(:start) }
    it { should respond_to(:stop) }
  end

  describe "::create" do
    it "creates a config object" do
      expect(MonitRB::Config.create).to be_a(MonitRB::Config)
    end

    it "is configurable through a block" do
      result = MonitRB::Config.create do |config|
        config.process = 'test'
      end

      expect(result.process).to eq('test')
    end
  end
end
