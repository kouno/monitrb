MonitRB::Config.define do |config|
  config.type       = :directory
  config.name       = 'dir'
  config.path       = '/path/to/dir/'
  config.conditions = ['if timestamp > 1 minute then alert']
end
