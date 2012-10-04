require 'spec_helper'
require './app/jobs/feed_fetcher'

describe FeedFetcher do

  it "should fetch and save feeds for all Item Sources" do
    feed = [Atom.new, Rss.new, RssFeedBurner.new]
    feed[0].name = "Atom"
    feed[0].url = "URL 1"
    feed[1].name = "Rss"
    feed[1].url = "URL 2"
    feed[2].name = "RssFeedBurner"
    feed[2].url = "URL 3"

    items = [Item.new,Item.new]


    Feed.should_receive(:all).and_return(feed)

    feed.each do |feed|
      feed.should_receive(:fetch_feed_entries).and_return(items)
    end

    items.each do |item|
      item.should_receive(:save).exactly(3)
    end

    FeedFetcher.get_all_feeds()
  end

end
