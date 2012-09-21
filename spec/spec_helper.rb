### TODO: FIX THIS
Dir["./models/**/*.rb"].each{ |f| require f }
Dir["./scripts/**/*.rb"].each{ |f| require f }
### FIX THIS

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.before(:each) do
    Mongoid.database.collections.each { |collection| collection.remove }
  end
end
