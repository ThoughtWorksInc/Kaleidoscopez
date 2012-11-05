require 'spec_helper'

describe FeedParser do

  before do
    @feed_entry = Feedzirra::Parser::AtomEntry.new
    @feed_entry.title = "First Post"
    @feed_entry.url = "test.url"
    @feed_entry.author = "Dave Thomas"
    @feed_entry.published = "2012-09-29 06:03:48 UTC"

    @source_image = "source_image_url"
    @source = Source.new(:has_summary=>true)
  end

  it "should create item object from a valid feed entry" do

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.title.should == "First Post"
    item.url.should == "test.url"
    item.author.should == "Dave Thomas"
    item.date.should ==  "2012-09-29 06:03:48 UTC"
    item.image.should == nil
    item.source.should == @source
  end

  it "should return item with image_url for image size greater than min area" do
    @feed_entry.summary = "<img src='www.test.com/image.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/image.jpg").and_return([200, 205])

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.image.should == "www.test.com/image.jpg"
  end

  it "should return item without image_url for image size lesser than min area" do
    @feed_entry.summary = "<img src='www.test.com/image.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/image.jpg").and_return([10, 10])

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.image.should == nil
  end

  it "should return item with image_url for valid image with url with escape characters" do
    @feed_entry.summary = "<img src='www.test.com/test image.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/test%20image.jpg").and_return([200, 205])

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.image.should == "www.test.com/test image.jpg"
  end

  it "should return item with image_url of largest image in the summary" do
    @feed_entry.summary = "<img src='www.test.com/image_one.jpg'/> <img src='www.test.com/image_two.jpg'/>"
    FastImage.should_receive(:size).with("www.test.com/image_one.jpg").and_return([200, 205])
    FastImage.should_receive(:size).with("www.test.com/image_two.jpg").and_return([200, 210])

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.image.should == "www.test.com/image_two.jpg"
  end

  it "should not generate webpage preview when there is an image available" do
    @feed_entry.summary = "<img src='some_image' />"
    FastImage.should_receive(:size).with("some_image").and_return([100,110])

    item = FeedParser.new.create_item @feed_entry, @source , @source_image

    item.webpage_preview.should be nil
  end


  it "should return item without image_url if the content of feed_entry has a image tag without src attribute" do
    @feed_entry.summary = "<img alt='oops! I dont have a source!'/>"

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.image.should be_nil
  end

  it "should return item with summary without HTML tags and new lines" do
    @feed_entry.summary = "<p>This is a test.</p>\n<a href=\"abcd.com\">Test is also code</a>"

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.summary.should == "This is a test. Test is also code..."
  end

  it "should return item without summary when has_summary is false" do
    @source = Source.new(:has_summary=>false)

    item = FeedParser.new.create_item(@feed_entry, @source , @source_image)

    item.title.should == "First Post"
    item.url.should == "test.url"
    item.author.should == "Dave Thomas"
    item.date.should ==  "2012-09-29 06:03:48 UTC"
    item.image.should == nil
    item.summary.should == nil
    item.source.should == @source

  end


  it "should return item with webpage preview" do
    mock_imgkit = "mock imgkit"
    mock_image = "Mock jpg Image"
    mock_file_handle = "mock file handle"

    IMGKit.should_receive(:new).with("test.url",quality: 50, width: 600).and_return(mock_imgkit)
    mock_imgkit.should_receive(:to_jpg).and_return(mock_image)
    File.should_receive(:new).with("public/images/preview/First290912060348.jpg","w").and_return(mock_file_handle)
    mock_file_handle.should_receive(:write).with(mock_image)
    mock_file_handle.should_receive(:flush)
    mock_file_handle.should_receive(:close)

    item = FeedParser.new.create_item(@feed_entry,@source,@source_image)

    item.webpage_preview.should == "/images/preview/First290912060348.jpg"
  end


  it "should not crash when IMGKit can't produce webpage preview" do
    mock_imgkit = "mock imgkit"
    IMGKit.should_receive(:new).with("test.url",quality: 50, width: 600).and_return(mock_imgkit)
    mock_imgkit.should_receive(:to_jpg).and_raise(RuntimeError.new("Test Exception"))

    item = FeedParser.new.create_item(@feed_entry,@source,@source_image)
    item.webpage_preview.should be nil
  end

  it "should not crash when image url contains more than 255 character" do
    very_long_text = "x"*256
    @feed_entry.summary = "<img src='#{very_long_text}' />"

    IMGKit.should_not_receive(:new).with(very_long_text,quality: 50, width: 60)

    FeedParser.new.create_item(@feed_entry,@source,@source_image)
  end
end
