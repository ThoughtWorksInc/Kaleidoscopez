require "spec_helper"
require_relative "../../../app/models/item"

describe Rss do


  before(:each) do

    @rss = Rss.new
    @feedzirra_rss = Feedzirra::Parser::RSS.new
    @rss.name = "Dummy Source"
    @rss.url = "feeds.dummy.com"
    @rss.save
  
    @feedzirra_rss.entries = [Feedzirra::Parser::RSSEntry.new, Feedzirra::Parser::RSSEntry.new]
    @feedzirra_rss.entries[0].title = "First Post"
    @feedzirra_rss.entries[0].url = "test.url"
    @feedzirra_rss.entries[0].author = "Dave Thomas"
    @feedzirra_rss.entries[0].summary = "<div><br /></div><div>(Side note: test)<br /><div><br /></div><div>test1</div><div><br /></div><div>Because we <i>care just enough</i> to feed our kids!</div><div><br /></div><div>test2</div></div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test.com' alt='' /></div>"
    @feedzirra_rss.entries[1].summary = "<div><br /></div><div>(Side note: test)<br /><div><br /></div><div>test1</div><div><br /></div><div>Because we <i>care just enough</i> to feed our kids!</div><div><br /></div><div>test2</div></div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test1.com' alt='' /></div>"
    @feedzirra_rss.entries[1].title = "Second Post"
    @feedzirra_rss.entries[1].url = "test1.url"
    @feedzirra_rss.entries[1].author = "Daven Thomas"
  end
  
  it "should fetch feeds as items" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(@rss.url).and_return(@feedzirra_rss)
    items = @rss.fetch_feed_entries()

    items[0].title.should == "First Post"
    items[0].url.should == "test.url"
    items[0].author.should == "Dave Thomas"
    items[0].date.should == nil
    items[0].image.should == "http://test.com"

    items[1].title.should == "Second Post"
    items[1].url.should == "test1.url"
    items[1].author.should == "Daven Thomas"
    items[1].date.should == nil
    items[1].image.should == "http://test1.com"

  end

end