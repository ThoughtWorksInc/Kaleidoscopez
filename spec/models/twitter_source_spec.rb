require "spec_helper"

describe TwitterSource do

  before(:each) do
  end

  it "should inherit source" do
    TwitterSource.ancestors.should include(Source)
  end

  it "fetch items" do
    twitter_source = TwitterSource.new({:query => 'pune'})
    Twitter.should_receive(:search).with("pune").and_return({:statuses => ["entry1", "entry2"]})
    TwitterParser.any_instance.should_receive(:create_item).twice.and_return(Item.new)

    items = twitter_source.fetch_items(10)

    items.count.should == 2
  end
end
