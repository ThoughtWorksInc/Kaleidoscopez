require "./spec/spec_helper"

describe Flickr do
  it "should inherit from Source" do
    Flickr.ancestors.include?(Source).should be true
  end

  it {should respond_to :tags}

  it "should fetch images from Flickr.com and create items" do
    flickr = Flickr.create({:name => "test", :tags => "test_tag1, test_tag2"})

    xml_response = "some xml response"
    HTTParty.should_receive(:get).with(URI.escape "http://api.flickr.com/services/feeds/photos_public.gne?tags=#{flickr.tags}&tagmode=any").and_return(xml_response)
    XmlSimple.should_receive(:xml_in).with(xml_response, :ForceArray => false).and_return({"entry" => ["entry_one", "entry_two"]})
    FlickrParser.any_instance.should_receive(:create_item).twice.and_return(Item.new)

    items = flickr.fetch_items(10)

    items.count.should == 2
  end
end