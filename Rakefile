require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :spec do
  desc 'For running on snap-ci, where imgkit is not available'
  RSpec::Core::RakeTask.new(:ci) do |t|
    t.rspec_opts = "--tag ~imgkit"
  end
end

namespace :db do
  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    seed_file = "db/seed.rb"
    puts "Seeding database from: #{seed_file}"
    load(seed_file) if File.exist?(seed_file)
   end
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
