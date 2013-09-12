require 'spec_helper'

describe MonitRB::CLI do
  before(:each) do
    FileUtils.cp([fixtures_path(%w{ monitrb ssh.rb }),
                  fixtures_path(%w{ monitrb resque.rb }),
                  fixtures_path(%w{ monitrb defaults.rb })], tmp_path)
  end

  after(:each) do
    File.delete(output_file) if File.exists?(output_file)
  end

  let(:output_file) { tmp_path('output.monitrc') }
  let(:config)      { File.read(fixtures_path('monitrb', 'resque.rb')) }

  describe "::build" do
    it "creates a monit configuration file" do
      MonitRB::CLI.start %w{ build --path=tmp/resque.rb --output=tmp/output.monitrc }
      expect(File.exists?(output_file)).to be_true
    end

    it "can use wildcards to use multiple files" do
      MonitRB::CLI.start %w{ build --path=tmp/*.rb --output=tmp/output.monitrc }
      expect(File.exists?(output_file)).to be_true
    end

    it "can use multiple arguments for paths" do
      MonitRB::CLI.start %w{ build -p tmp/ssh.rb,tmp/*.rb -o tmp/output.monitrc }
      expect(File.exists?(output_file)).to be_true
    end

    it "can require a ruby file to define defaults" do
      pending 'Needs implementation'
      MonitRB::CLI.start %w{ build -p tmp/ssh.rb -o tmp/output.monitrc --defaults tmp/options.rb }
      expect(File.exists?(output_file)).to be_true
    end
  end
end
