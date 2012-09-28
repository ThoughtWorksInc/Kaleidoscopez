require "spec_helper"
require_relative "../../../app/models/item"

describe Rss do
  rss = Rss.new
  feedzirra_rss = Feedzirra::Parser::RSS.new


  before(:each) do
    rss.name = "Dummy Source"
    rss.url = "feeds.dummy.com"
    rss.save

    feedzirra_rss.entries = [Feedzirra::Parser::RSSEntry.new, Feedzirra::Parser::RSSEntry.new]
    feedzirra_rss.entries[0].title = "First Post"
    feedzirra_rss.entries[0].url = "test.url"
    feedzirra_rss.entries[0].author = "Dave Thomas"
    feedzirra_rss.entries[1].title = "Second Post"
    feedzirra_rss.entries[1].url = "test1.url"
    feedzirra_rss.entries[1].author = "Daven Thomas"
  end

  it "should fetch feeds" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(rss.url).and_return(feedzirra_rss)
    rss.fetch_feed_entries()

  end

  it "should create item from the rss feed and add it to the database" do
    rss.create_item(feedzirra_rss)

    rss.items[0].title.should == "First Post"
    rss.items[0].url.should == "test.url"
    rss.items[0].author.should == "Dave Thomas"
    rss.items[0].date.should == nil

    rss.items[1].title.should == "Second Post"
    rss.items[1].url.should == "test1.url"
    rss.items[1].author.should == "Daven Thomas"
    rss.items[1].date.should == nil

  end

end