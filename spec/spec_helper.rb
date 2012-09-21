require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.database.collections.each { |collection| collection.remove }
  end
end
