require 'spec_helper'

describe FeedParser do
  
  before do
    @feed_entry = Feedzirra::Parser::AtomEntry.new
    @feed_entry.title = "First Post"
    @feed_entry.url = "test.url"
    @feed_entry.author = "Dave Thomas"
    @feed_entry.published = "2012-09-29 06:03:48 UTC"

    @source = Source.new
  end

  it "should create item object from a valid feed entry" do

    item = FeedParser.new.create_item(@feed_entry, @source)

    item.title.should == "First Post"
    item.url.should == "test.url"
    item.author.should == "Dave Thomas"
    item.date.should ==  "2012-09-29 06:03:48 UTC"
    item.image.should == nil
    item.source.should == @source
  end

  it "should return item with image_url for image size greater than min area" do
    @feed_entry.content = "<img src='www.test.com/image.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/image.jpg").and_return([100,105])

    item = FeedParser.new.create_item(@feed_entry, @source)

    item.image.should == "www.test.com/image.jpg"
  end

  it "should return item without image_url for image size lesser than min area" do
    @feed_entry.content = "<img src='www.test.com/image.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/image.jpg").and_return([10,10])

    item = FeedParser.new.create_item(@feed_entry, @source)

    item.image.should == nil
  end

  it "should return item with image_url for valid image with url with escape characters" do
    @feed_entry.content = "<img src='www.test.com/test image.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/test%20image.jpg").and_return([100,105])

    item = FeedParser.new.create_item(@feed_entry, @source)

    item.image.should == "www.test.com/test image.jpg"
  end

  it "should return item with image_url of largest image in the content" do
    @feed_entry.content = "<img src='www.test.com/image_one.jpg'/> <img src='www.test.com/image_two.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/image_one.jpg").and_return([100,105])
    FastImage.should_receive(:size).with("www.test.com/image_two.jpg").and_return([100,110])

    item = FeedParser.new.create_item(@feed_entry, @source)

    item.image.should == "www.test.com/image_two.jpg"
  end


end