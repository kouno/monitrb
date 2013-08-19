require 'spec_helper'

describe MonitRB::CLI do
  before(:each) do
    File.open(input_file, 'w') { |f| f.write(config) }
  end

  after(:each) do
    File.delete(input_file)  if File.exists?(input_file)
    File.delete(output_file) if File.exists?(output_file)
  end

  let(:input_file)  { tmp_path('input.rb') }
  let(:output_file) { tmp_path('output.monitrc') }
  let(:config)      { File.read(fixtures_path('monitrb', 'resque.rb')) }

  describe "::build" do
    it "creates a monit configuration file" do
      MonitRB::CLI.start %w{ build --path=tmp/input.rb --output=tmp/output.monitrc }
      expect(File.exists?(output_file)).to be_true
    end

    it "can use wildcards to use multiple files" do
      MonitRB::CLI.start %w{ build --path=tmp/*.rb --output=tmp/output.monitrc }
      expect(File.exists?(output_file)).to be_true
    end
  end
end
