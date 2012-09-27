require "spec_helper"

describe Radiator do

  it "should fetch all news in array" do
    Item.all.to_a.to_json
    feeds = ['a','b','c','d','e','f','g','h','i','j','k','l','m']

    Item.should_receive(:all).and_return(feeds)
    feeds.should_receive(:to_a).and_return(feeds)

    feed_source1 = Feed.new
    feed_source1._id = BSON::ObjectId.new
    feed_source1.name = "abcd"

    feed_source2 = Feed.new
    feed_source1._id = BSON::ObjectId.new
    feed_source1.name = "pqrs"

    feed_sources = [feed_source1, feed_source2]
    Feed.should_receive(:all).and_return(feed_sources)

    all_news_json = Radiator.new!.get_all_news
    (all_news_json.is_a? String).should == true

    all_news_map = JSON.parse all_news_json

    all_feeds = all_news_map["feeds"]
    feeds.should_not == all_feeds
    feeds.each do |feed|
      (all_feeds.include? feed).should == true
    end

    all_sources = all_news_map["sources"]
    feed_sources.each do |feed_source|
      all_sources[feed_source._id.to_s].should == feed_source.name
    end
 end
end