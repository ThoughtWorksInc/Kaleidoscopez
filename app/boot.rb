ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

require "feedzirra"
require "mongoid"
require "./app/helpers/helpers"
require "./app/models/models"

Mongoid.load!('config/mongoid.yml',ENV["RACK_ENV"])
SourceLogger.logger(Logger.new './log/source.log')
