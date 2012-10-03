ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

Dir["./app/models/**/*.rb"].each { |f| require f }
Dir["./scripts/**/*.rb"].each { |f| require f }

require_relative '../app'

Mongoid.load!('config/mongoid.yml',ENV["RACK_ENV"])
