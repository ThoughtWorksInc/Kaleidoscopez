ENV['RACK_ENV'] = 'test'

require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |config|

  config.before(:each) do
    Mongoid.database.collections.each do |collection|
      collection.remove unless collection.name =~ /^system\./
    end
  end
end
