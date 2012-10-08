require 'clockwork'
require './app/boot'
require "./app/jobs/source_fetcher"

include Clockwork

every(10.minute , "feeds.refresh") {SourceFetcher.get_all_items}