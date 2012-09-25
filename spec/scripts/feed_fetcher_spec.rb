require 'spec_helper'

describe FeedFetcher do

  it "should fetch and save feeds for given feed url" do
    blog = Feedzirra::Parser::Atom.new
    blog.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    blog.entries[0].title = "First Post"
    blog.entries[0].url = "test.url"
    blog.entries[0].author = "Dave Thomas"
    blog.entries[1].title = "Second Post"
    blog.entries[1].url = "test1.url"
    blog.entries[1].author = "Daven Thomas"

    feed_source = FeedSource.new
    feed_source.name = "Dummy Source"
    feed_source.url = "feeds.dummy.com"

    Feedzirra::Feed.should_receive(:fetch_and_parse).with(feed_source.url).and_return(blog)


    FeedFetcher.get_feed(feed_source)
    feed_source.feeds.count.should == 2
    feed_source.feeds[0].title.should == "First Post"
    feed_source.feeds[0].url.should == "test.url"
    feed_source.feeds[0].author.should == "Dave Thomas"
    feed_source.feeds[0].feed_source.should == feed_source

    feed_source.feeds[1].title.should == "Second Post"
    feed_source.feeds[1].url.should == "test1.url"
    feed_source.feeds[1].author.should == "Daven Thomas"
    feed_source.feeds[1].feed_source.should == feed_source
  end

  it "should fetch and save feeds for all Feed Sources" do
    feed_sources = [FeedSource.new, FeedSource.new]
    feed_sources[0].name = "Name 1"
    feed_sources[0].url = "URL 1"
    feed_sources[1].name = "Name 2"
    feed_sources[1].url = "URL 2"

    FeedSource.should_receive(:all).and_return(feed_sources)

    feed_sources.each do |feed_source|
      FeedFetcher.should_receive(:get_feed).with(feed_source)
    end

    FeedFetcher.get_all_feeds()
  end
end
