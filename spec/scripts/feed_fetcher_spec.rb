require 'spec_helper'

describe FeedFetcher do

  it "should fetch and save feeds from given feed url and delete existing feeds from the same source" do
    blog = Feedzirra::Parser::Atom.new
    blog.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    blog.entries[0].title = "First Post"
    blog.entries[0].url = "test.url"
    blog.entries[0].author = "Dave Thomas"
    blog.entries[1].title = "Second Post"
    blog.entries[1].url = "test1.url"
    blog.entries[1].author = "Daven Thomas"

    feed = Feed.new
    feed.name = "Dummy Source"
    feed.url = "feeds.dummy.com"
    feed.save

    Feedzirra::Feed.should_receive(:fetch_and_parse).with(feed.url).and_return(blog)
    Item.should_receive(:delete_all).with(conditions: {:url => feed.url})


    FeedFetcher.get_feed(feed)
    feed.items.count.should == 2
    feed.items[0].title.should == "First Post"
    feed.items[0].url.should == "test.url"
    feed.items[0].author.should == "Dave Thomas"
    feed.items[0].feed.should == feed

    feed.items[1].title.should == "Second Post"
    feed.items[1].url.should == "test1.url"
    feed.items[1].author.should == "Daven Thomas"
    feed.items[1].feed.should == feed
  end

  it "should fetch and save feeds for all Item Sources" do
    feed = [Feed.new, Feed.new]
    feed[0].name = "Name 1"
    feed[0].url = "URL 1"
    feed[1].name = "Name 2"
    feed[1].url = "URL 2"

    Feed.should_receive(:all).and_return(feed)

    feed.each do |feed|
      FeedFetcher.should_receive(:get_feed).with(feed)
    end

    FeedFetcher.get_all_feeds()
  end
end
