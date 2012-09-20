require "mongoid"

configure do
  Mongoid.configure do |config|
    name = "kaleidoscope"
    host = "localhost"
    config.master = Mongo::Connection.new.db(name)
    config.persist_in_safe_mode = false
  end
end
