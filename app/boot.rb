ENV["RACK_ENV"] ||= "development"

require 'bundler'

Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

$:.unshift "#{File.dirname(__FILE__)}/lib"

require "feedzirra"
require "mongoid"
require "./app/helpers/helpers"
require "./app/models/models"

Mongoid.load!('config/mongoid.yml',ENV["RACK_ENV"])
Dir.mkdir("./log",0777) if !File.directory? "./log"
SourceLogger.logger(Logger.new './log/source.log')
