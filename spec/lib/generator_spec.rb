require 'spec_helper'

describe MonitRB::Generator do
  subject { MonitRB::Generator }

  let(:expected_conf) { File.read(fixtures_path('monit', 'resque.monitrc')) }

  before(:each) do
    load fixtures_path('monitrb', 'resque.rb')
  end

  describe "#parse" do
    it "produces a monit configuration" do
      expect(subject.parse(MonitRB::Config.stack).to_s).to eq(expected_conf)
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
      expect(File.read(filepath)).to eq(expected_conf)
    end
  end

  describe "#add" do
    describe "raw config" do
      before(:each) do
        config.raw = "test"
      end

      let(:config) { MonitRB::Config.new }

      it "uses no template" do
        generator = subject.new
        expect(-> { generator.add(config) }).to_not raise_error
        expect(generator.configs.first).to eq 'test'
      end
    end
  end
end
