ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

Dir["./models/**/*.rb"].each { |f| require f }
Dir["./scripts/**/*.rb"].each { |f| require f }

require './radiator.rb'

configure do
  config = Mongoid.load!('config/mongoid.yml')
  uri = config["uri"]
  name = URI.parse(uri).path.gsub(/^\//, '')

  Mongoid.configure do |config|
    config.master = Mongo::Connection.from_uri(uri).db(name)
    config.persist_in_safe_mode = false
  end
end
