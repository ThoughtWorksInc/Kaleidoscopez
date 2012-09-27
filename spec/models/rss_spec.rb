require "spec_helper"

describe Rss do

  it "should fetch feeds" do
    rss = Rss.new
    rss.name = "Dummy Source"
    rss.url = "feeds.dummy.com"
    feedzirra_rss = Feedzirra::Parser::RSS.new
    feedzirra_rss.entries = [Feedzirra::Parser::RSSEntry.new, Feedzirra::Parser::RSSEntry.new]
    feedzirra_rss.entries[0].title = "First Post"
    feedzirra_rss.entries[0].url = "test.url"
    feedzirra_rss.entries[0].author = "Dave Thomas"
    feedzirra_rss.entries[1].title = "Second Post"
    feedzirra_rss.entries[1].url = "test1.url"
    feedzirra_rss.entries[1].author = "Daven Thomas"

    Feedzirra::Feed.should_receive(:fetch_and_parse).with(rss.url).and_return(feedzirra_rss)

    rss.fetch_feeds()

  end
end