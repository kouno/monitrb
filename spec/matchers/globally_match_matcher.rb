RSpec::Matchers.define :globally_match do |expected|
  match do |actual|
    actual.gsub!(/ +|\n+/, '')
    expected.gsub!(/ +|\n+/, '')
    actual == expected
  end
end
