require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)


task :default => :spec

namespace :db do
  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    seed_file = "./seed.rb"
    puts "Seeding database from: #{seed_file}"
    load(seed_file) if File.exist?(seed_file)
   end
end