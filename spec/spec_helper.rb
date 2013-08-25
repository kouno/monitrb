require File.expand_path('../../lib/monitrb.rb', __FILE__)
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.after(:each) do
    MonitRB::Config.clear_stack
  end

  config.include SpecPaths
end
