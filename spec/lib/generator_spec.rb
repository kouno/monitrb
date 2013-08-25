require 'spec_helper'

describe MonitRB::Generator do
  subject { MonitRB::Generator }

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
