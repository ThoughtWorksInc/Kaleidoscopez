require "spec_helper"

describe RssFeedBurner do

  it "should fetch feeds" do
    feedBurner = RssFeedBurner.new
    feedBurner.name = "Dummy Source"
    feedBurner.url = "feeds.dummy.com"
    feedzirra_feedBurner = Feedzirra::Parser::RSSFeedBurner.new
    feedzirra_feedBurner.entries = [Feedzirra::Parser::RSSFeedBurnerEntry.new, Feedzirra::Parser::RSSFeedBurnerEntry.new]
    feedzirra_feedBurner.entries[0].title = "First Post"
    feedzirra_feedBurner.entries[0].url = "test.url"
    feedzirra_feedBurner.entries[0].author = "Dave Thomas"
    feedzirra_feedBurner.entries[1].title = "Second Post"
    feedzirra_feedBurner.entries[1].url = "test1.url"
    feedzirra_feedBurner.entries[1].author = "Daven Thomas"

    Feedzirra::Feed.should_receive(:fetch_and_parse).with(feedBurner.url).and_return(feedzirra_feedBurner)

    feedBurner.fetch_feeds()

  end
end