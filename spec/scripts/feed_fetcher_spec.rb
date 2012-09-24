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

    Feedzirra::Feed.should_receive(:fetch_and_parse).with("feeds.dummy.com").and_return(blog)

    FeedFetcher.get_feed("feeds.dummy.com")
    Feed.count.should == 2
    Feed.all[0].title.should == "First Post"
    Feed.all[0].url.should == "test.url"
    Feed.all[0].author.should == "Dave Thomas"
    Feed.all[1].title.should == "Second Post"
    Feed.all[1].url.should == "test1.url"
    Feed.all[1].author.should == "Daven Thomas"
  end

  it "should fetch and save feeds for all Feed Sources" do
    feed_sources = [FeedSource.new, FeedSource.new]
    feed_sources[0].name = "Name 1"
    feed_sources[0].url = "URL 1"
    feed_sources[1].name = "Name 2"
    feed_sources[1].url = "URL 2"

    FeedSource.should_receive(:all).and_return(feed_sources)

    feed_sources.each do |feed_source|
      FeedFetcher.should_receive(:get_feed).with(feed_source.url)
    end

    FeedFetcher.get_all_feeds()
  end
end
