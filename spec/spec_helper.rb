require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require 'method_fixtures'

def pry!
  require 'pry-byebug'
  binding.pry
end

TestFixtures = MethodFixtures::FixtureRepository.new("#{Dir.pwd}/spec/support/generated_method_fixtures")
