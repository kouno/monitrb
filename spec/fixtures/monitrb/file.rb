MonitRB::Config.define do |config|
  config.type       = :file
  config.name       = 'file.md'
  config.path       = '/path/to/file'
  config.conditions = ['if timestamp > 1 minute then alert']
end
