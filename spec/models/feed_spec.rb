require 'spec_helper'
require 'feedzirra'

describe Feed do
  it {should respond_to :url}

  it "should inherit Source" do
    Feed.ancestors.include?(Source).should be true
  end

  before(:each) do
    @feed = Feed.create(:name => "Dummy Source", :url => "feeds.dummy.com", :last_fetched_at => Time.now)
    @feedzirra_feed = Feedzirra::Parser::Atom.new

    @feedzirra_feed.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    @feedzirra_feed.entries[0].title = "First Post"
    @feedzirra_feed.entries[0].url = "test.url"
    @feedzirra_feed.entries[0].author = "Dave Thomas"
    @feedzirra_feed.entries[0].published = "2012-09-29 06:03:48 UTC"
    @feedzirra_feed.entries[0].content = "<div>test2</div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test2.com' alt='' /></div>"
    @feedzirra_feed.entries[1].title = "Second Post"
    @feedzirra_feed.entries[1].url = "test1.url"
    @feedzirra_feed.entries[1].author = "Daven Thomas"
    @feedzirra_feed.entries[1].published = "2013-09-29 06:03:48 UTC"
    @feedzirra_feed.entries[1].content = "<img src='http://test.com/a b'/><img src='http://test300x400.com'/>"
  end

  it "should fetch feeds as items" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(@feed.url, {:if_modified_since => @feed.last_fetched_at}).and_return(@feedzirra_feed)
    FastImage.should_receive(:size).with("http://test2.com").and_return([1,1])
    FastImage.should_receive(:size).with("http://test.com/a%20b").and_return([200,200])
    FastImage.should_receive(:size).with("http://test300x400.com").and_return([300,400])
    items = @feed.fetch_items(15)

    items[0].title.should == "First Post"
    items[0].url.should == "test.url"
    items[0].author.should == "Dave Thomas"
    items[0].date.should ==  "2012-09-29 06:03:48 UTC"
    items[0].image.should == nil
    items[0].source.should == @feed

    items[1].title.should == "Second Post"
    items[1].url.should == "test1.url"
    items[1].author.should == "Daven Thomas"
    items[1].date.should == "2013-09-29 06:03:48 UTC"
    items[1].image.should == "http://test300x400.com"
    items[1].source.should == @feed
  end

end

