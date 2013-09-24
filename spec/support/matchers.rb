RSpec::Matchers.define :be_similar_to do |expected|
  match do |actual|
    actual.gsub(/^ +/, '').gsub(/\n/, '') == expected.gsub(/^ +/, '').gsub(/\n/, '')
  end

  diffable
end
