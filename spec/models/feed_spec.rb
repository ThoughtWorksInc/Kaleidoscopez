require 'spec_helper'
require 'feedzirra'

describe Feed do
  it {should respond_to :url}
  it {should respond_to :source_image}
  it {should respond_to :has_summary}

  it "should inherit Source" do
    Feed.ancestors.include?(Source).should be true
  end

  before(:each) do
    @feed = Feed.create(:name => "Dummy Source", :url => "feeds.dummy.com", :source_image => "feeds.dummy.gif",:last_fetched_at => Time.now)
    @feedzirra_feed = Feedzirra::Parser::Atom.new
    @feedzirra_feed.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
  end

  it "should fetch feeds as items" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(@feed.url, {:if_modified_since => @feed.last_fetched_at}).and_return(@feedzirra_feed)
    FeedParser.any_instance.should_receive(:create_item).twice.and_return(Item.new)

    items = @feed.fetch_items(10)

    items.count.should == 2
  end

end

