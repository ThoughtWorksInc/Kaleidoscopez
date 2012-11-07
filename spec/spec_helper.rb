require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

ENV['RACK_ENV'] = 'test'

require File.expand_path(File.dirname(__FILE__) + "/../app/app")

RSpec.configure do |config|

  config.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end

end
RSpec.configure do |config|
  config.before(:each) { SourceLogger.logger(Logger.new './log/test.log') }
end