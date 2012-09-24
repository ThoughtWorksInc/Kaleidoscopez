ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

Dir["./models/**/*.rb"].each { |f| require f }
Dir["./scripts/**/*.rb"].each { |f| require f }

require './radiator.rb'

configure do
  db_config = Mongoid.load!('mongoid.yml')
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db(db_config["database"])
    config.persist_in_safe_mode = false
  end
end
