require 'spec_helper'
require './app/jobs/feed_fetcher'

describe FeedFetcher do

  before(:each) do
    @feed = Feed.create(:name => "Lion King", :url => "lion.king.com")

    @items = 11.times.collect { Item.new }
    @items_less_than_ten = 3.times.collect { Item.new }
  end


  it "should delete and save items if number of items greater than 10" do
    Feed.should_receive(:all).and_return([@feed])

    @feed.should_receive(:fetch_feed_entries).and_return(@items)

    @items.each do |item|
      item.should_receive(:save)
    end

    Item.should_receive(:delete_all)

    FeedFetcher.get_all_feeds
  end


  it "should not delete and save items if number of items lesser than 10" do
    Feed.should_receive(:all).and_return([@feed])

    @feed.should_receive(:fetch_feed_entries).and_return(@items_less_than_ten)

    Item.should_not_receive(:delete_all)

    @items_less_than_ten.each do |item|
      item.should_not_receive(:save)
    end

    FeedFetcher.get_all_feeds
  end

end
