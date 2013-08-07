require 'spec_helper'

describe MonitRB::Config do
  it "creates a config object" do
    expect(MonitRB::Config.create).to be_a(MonitRB::Config)
  end
end
