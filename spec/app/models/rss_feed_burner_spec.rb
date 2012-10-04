require "spec_helper"
require_relative "../../../app/models/item"

describe RssFeedBurner do
  feedburner = RssFeedBurner.new
  feedzirra_feedburner = Feedzirra::Parser::RSSFeedBurner.new


  before(:each) do
    feedburner.name = "Dummy Source"
    feedburner.url = "feeds.dummy.com"
    feedburner.save

    feedzirra_feedburner.entries = [Feedzirra::Parser::RSSFeedBurnerEntry.new, Feedzirra::Parser::RSSFeedBurnerEntry.new]
    feedzirra_feedburner.entries[0].title = "First Post"
    feedzirra_feedburner.entries[0].url = "test.url"
    feedzirra_feedburner.entries[0].author = "Dave Thomas"
    feedzirra_feedburner.entries[0].published = "2012-09-28 06:03:48 UTC"
    feedzirra_feedburner.entries[0].summary = "<div><br /></div><div>(Side note: test)<br /><div><br /></div><div>test1</div><div><br /></div><div>Because we <i>care just enough</i> to feed our kids!</div><div><br /></div><div>test2</div></div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test.com' alt='' /></div>"
    feedzirra_feedburner.entries[1].title = "Second Post"
    feedzirra_feedburner.entries[1].url = "test1.url"
    feedzirra_feedburner.entries[1].author = "Daven Thomas"
    feedzirra_feedburner.entries[1].published = "2012-09-29 06:03:48 UTC"
    feedzirra_feedburner.entries[1].summary = "<div><br /></div><div>(Side note: test)<br /><div><br /></div><div>test1</div><div><br /></div><div>Because we <i>care just enough</i> to feed our kids!</div><div><br /></div><div>test2</div></div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test2.com' alt='' /></div>"

  end

  it "should fetch feeds" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(feedburner.url).and_return(feedzirra_feedburner)
    feedburner.fetch_feed_entries()

  end

  it "should create item from the rss FeedBurner feed and add it to the database" do

    feedburner.create_item(feedzirra_feedburner)

    feedburner.items[0].title.should == "First Post"
    feedburner.items[0].url.should == "test.url"
    feedburner.items[0].author.should == "Dave Thomas"
    feedburner.items[0].date.should == "2012-09-28"
    feedburner.items[0].image.should == "http://test.com"


    feedburner.items[1].title.should == "Second Post"
    feedburner.items[1].url.should == "test1.url"
    feedburner.items[1].author.should == "Daven Thomas"
    feedburner.items[1].date.should == "2012-09-29"
    feedburner.items[1].image.should == "http://test2.com"


  end

end