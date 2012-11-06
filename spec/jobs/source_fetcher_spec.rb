require 'spec_helper'
require './app/jobs/source_fetcher'

describe SourceFetcher do

  before(:each) do
    @feed_source = Feed.create(:name => "Lion King", :url => "lion.king.com")
    @twitter_source  = TwitterSource.create(:name => "Twitter", :query => "twitter")

    @feed_items = 5.times.collect { Item.new }
    @twitter_items = 6.times.collect { Item.new }

    @items_less_than_ten = 3.times.collect { Item.new }
  end

  it "should be singleton" do
     SourceFetcher.ancestors.include?(Singleton).should be true
  end

  it "should delete and save items if number of items greater than 10" do
    Source.should_receive(:all).and_return([@feed_source, @twitter_source])

    @feed_source.should_receive(:fetch_items).and_return(@feed_items)
    @twitter_source.should_receive(:fetch_items).and_return(@twitter_items)

    all_items = @feed_items + @twitter_items
    all_items.each do |item|
      item.should_receive(:save)
    end

    Item.should_receive(:delete_all)

    SourceFetcher.instance.get_all_items
  end


  it "should not delete and save items if number of items lesser than 10" do
    Source.should_receive(:all).and_return([@feed_source])

    @feed_source.should_receive(:fetch_items).and_return(@items_less_than_ten)

    Item.should_not_receive(:delete_all)

    @items_less_than_ten.each do |item|
      item.should_not_receive(:save)
    end

    SourceFetcher.instance.get_all_items
  end

end
