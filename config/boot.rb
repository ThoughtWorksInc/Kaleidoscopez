ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

Dir["./models/**/*.rb"].each { |f| require f }
Dir["./scripts/**/*.rb"].each { |f| require f }

require './radiator.rb'

configure do
  Mongoid.configure do |config|
    name = "kaleidoscope"
    host = "localhost"
    config.master = Mongo::Connection.new.db(name)
    config.persist_in_safe_mode = false
  end
end
