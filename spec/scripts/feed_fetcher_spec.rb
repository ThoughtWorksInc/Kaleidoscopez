require 'spec_helper'
require './app/jobs/feed_fetcher'

describe FeedFetcher do

  before(:each) do
    @feed = [Atom.new, Rss.new, RssFeedBurner.new]
    @feed[0].name = "Atom"
    @feed[0].url = "URL 1"
    @feed[1].name = "Rss"
    @feed[1].url = "URL 2"
    @feed[2].name = "RssFeedBurner"
    @feed[2].url = "URL 3"

    @items = [Item.new,Item.new,Item.new,Item.new,Item.new,Item.new,Item.new,Item.new,Item.new,Item.new,Item.new]
    @items_less_than_ten = [Item.new,Item.new]

  end


  it "should fetch feeds for all Item Sources" do

    Feed.should_receive(:all).and_return(@feed)

    @feed.each do |feed|
      feed.should_receive(:fetch_feed_entries).and_return(@items)
    end

    FeedFetcher.get_all_feeds
  end


  it "should delete and save items if number of items greater than 10" do

    Feed.should_receive(:all).and_return(@feed)

    @feed.each do |feed|
      feed.should_receive(:fetch_feed_entries).and_return(@items)
    end

    Item.should_receive(:delete_all)

    @items.each do |item|
      item.should_receive(:save).exactly(3)
    end

    FeedFetcher.get_all_feeds

  end


  it "should not delete and save items if number of items lesser than 10" do

    Feed.should_receive(:all).and_return(@feed)

    @feed.each do |feed|
      feed.should_receive(:fetch_feed_entries).and_return(@items_less_than_ten)
    end

    Item.should_not_receive(:delete_all)

    @items_less_than_ten.each do |item|
      item.should_not_receive(:save)
    end

    FeedFetcher.get_all_feeds

  end

end
