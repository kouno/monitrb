require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonitRB::Config, "Supported checks" do
  it "supports file checks" do
    load fixtures_path(%w{ monitrb file.rb })
    expected_conf = File.read(fixtures_path(%w{ monit file.monitrc }))
    expect(MonitRB::Config.stack.first.to_s).to eq(expected_conf)
  end

  it "supports directory check" do
    load fixtures_path(%w{ monitrb directory.rb })
    expected_conf = File.read(fixtures_path(%w{ monit directory.monitrc }))
    expect(MonitRB::Config.stack.first.to_s).to eq(expected_conf)
  end
end
