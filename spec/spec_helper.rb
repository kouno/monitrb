require File.expand_path('../../lib/monitrb.rb', __FILE__)
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) do
    MonitRB::Config.clear_stack
  end
end
