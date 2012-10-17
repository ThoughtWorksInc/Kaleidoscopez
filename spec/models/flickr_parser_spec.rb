require "spec_helper"

describe FlickrParser do

  it "should fetch images from Flickr.com and create items" do
    source = Source.new
    item = FlickrParser.new.create_item(flickr_entry, source)
    item.title.should == "title"
    item.url.should == "page_link"
    item.image.should == "image_link"
    item.author.should == "author_name"
    item.author_image.should == "author_image"
    item.date.should == Time.utc(2012,"oct",11,10,04,17)
    item.source.should == source

  end

  def flickr_entry
    {
        "title" => "title",
        "link" =>
            [{
                 "rel" => "alternate",
                 "href" => "page_link"
             },
             {
                 "rel" => "enclosure",
                 "href" => "image_link"
             }],
        "published" => "2012-10-11T10:04:17Z",
        "author" =>
            {
                "name" => "author_name",
                "buddyicon" => "author_image"
            }
    }
  end

end