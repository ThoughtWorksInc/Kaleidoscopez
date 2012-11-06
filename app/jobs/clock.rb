require './app/boot'
require "./app/jobs/source_fetcher"

SourceFetcher.instance.get_all_items
