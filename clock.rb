require 'clockwork'
include Clockwork
require './config/boot'

handler do |job|
  puts "Running job #{job}"
end

every(10.minute , "feeds.refresh") {FeedFetcher.get_all_feeds}