if ENV['START_SIMPLECOV'].to_i == 1
  require 'gem_hadar/simplecov'
  GemHadar::SimpleCov.start
end
begin
  require 'debug'
rescue LoadError
end
require 'test/unit'
require 'tins'
