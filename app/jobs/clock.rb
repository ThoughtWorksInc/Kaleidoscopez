require 'clockwork'
require './app/boot'
require "./app/jobs/feed_fetcher"

include Clockwork

every(10.minute , "feeds.refresh") {FeedFetcher.get_all_feeds}