require 'spec_helper'

describe MonitRB::Config do
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
