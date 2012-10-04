require 'clockwork'
require '../boot'

include Clockwork

every(10.minute , "feeds.refresh") {FeedFetcher.get_all_feeds}