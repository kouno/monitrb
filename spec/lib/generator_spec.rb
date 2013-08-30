require 'spec_helper'

describe MonitRB::Generator do
  subject { MonitRB::Generator.new }

  let(:expected_conf) { File.read(fixtures_path('monit', 'resque.monitrc')) }

  before(:each) do
    load fixtures_path('monitrb', 'resque.rb')
  end

  describe "#load" do
    it "produces a monit configuration" do
      expect(subject.load(MonitRB::Config.stack).to_s).to eq(expected_conf)
    end

    describe "raw config" do
      before(:each) do
        config.raw = "test"
      end

      let(:config) { MonitRB::Config.new }

      it "uses no template" do
        expect(-> { subject.load([config]) }).to_not raise_error
        expect(subject.configs.first.to_s).to eq 'test'
      end
    end
  end

  describe "#write" do
    before(:each) do
      FileUtils.rm(filepath) if File.exists?(filepath)
      subject.load(MonitRB::Config.stack).write_to(filepath)
    end

    after(:each) do
      FileUtils.rm(filepath) if File.exists?(filepath)
    end

    let(:filepath) { File.join('tmp', 'monit.conf') }

    it "writes file to specified folder" do
      expect(File.exists?(filepath)).to be_true
      expect(File.read(filepath)).to eq(expected_conf)
    end
  end
end
