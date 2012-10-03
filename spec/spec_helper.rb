ENV['RACK_ENV'] = 'test'

require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |config|

  config.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end

end
