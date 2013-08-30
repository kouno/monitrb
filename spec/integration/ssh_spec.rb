require 'spec_helper'

describe "simple SSH config" do
  let(:expected_conf) { File.read(fixtures_path('monit', 'ssh.monitrc')) }

  before(:each) do
    load fixtures_path('monitrb', 'ssh.rb')
  end

  describe "#parse" do
    it "produces a monit configuration" do
      expect(MonitRB::Generator.new.load(MonitRB::Config.stack).to_s).to eq(expected_conf)
    end
  end
end
