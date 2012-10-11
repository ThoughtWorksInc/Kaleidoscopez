require "./spec/spec_helper"

describe Flickr do
  it "should inherit from Source" do
    Flickr.ancestors.include?(Source).should be true
  end

  it {should respond_to :tags}

  it "should fetch images from Flickr.com and create items" do
    flickr = Flickr.create({:name => "test", :tags => "test_tag1, test_tag2"})
    flickr_url = URI.escape "http://api.flickr.com/services/feeds/photos_public.gne?tags=#{flickr.tags}"
    xml_response = "abcd"
    HTTParty.should_receive(:get).with(flickr_url).and_return(xml_response)
    flickr_content = {
        "entry" => [
            {"title" => "title 1",
             "link" =>
                 [{
                    "rel" => "alternate",
                     "type" => "text/html",
                     "href" => "page_link1"
                  },
                  {
                      "rel" => "enclosure",
                      "type" => "image/jpeg",
                      "href" => "image_link1"
                  }],
             "published" => "2012-10-11T10:04:17Z",
             "author" =>
                 {
                    "name" => "author_name1",
                    "buddyicon" => "author_image1"
                 },
             "category" =>
                 {
                    "term" => "tag1", "scheme" => "http://www.flickr.com/photos/tags/",
                    "term" => "tag2", "scheme" => "http://www.flickr.com/photos/tags/"
                 }
            },
            {"title" => "title 2",
             "link" =>
                 [{
                      "rel" => "alternate",
                      "type" => "text/html",
                      "href" => "page_link2"
                  },
                  {
                      "rel" => "enclosure",
                      "type" => "image/jpeg",
                      "href" => "image_link2"
                  }],
             "published" => "2012-10-12T10:04:17Z",
             "author" =>
                 {
                     "name" => "author_name2",
                     "buddyicon" => "author_image2"
                 },
             "category" =>
                 {
                     "term" => "tag3", "scheme" => "http://www.flickr.com/photos/tags/",
                     "term" => "tag4", "scheme" => "http://www.flickr.com/photos/tags/"
                 }
            }
        ]
    }
    XmlSimple.should_receive(:xml_in).with(xml_response,:ForceArray => false).and_return(flickr_content)
    items = flickr.fetch_items 10
    items[0].title.should == flickr_content["entry"][0]["title"]
    items[0].url.should == flickr_content["entry"][0]["link"][0]["href"]
    items[0].image.should == flickr_content["entry"][0]["link"][1]["href"]
    items[0].author.should == flickr_content["entry"][0]["author"]["name"]
    items[0].author_image.should == flickr_content["entry"][0]["author"]["buddyicon"]
    items[0].date.should == Time.utc(2012,"oct",11,10,04,17)

    items[1].title.should == flickr_content["entry"][1]["title"]
    items[1].url.should == flickr_content["entry"][1]["link"][0]["href"]
    items[1].image.should == flickr_content["entry"][1]["link"][1]["href"]
    items[1].author.should == flickr_content["entry"][1]["author"]["name"]
    items[1].author_image.should == flickr_content["entry"][1]["author"]["buddyicon"]
    items[1].date.should == Time.utc(2012,"oct",12,10,04,17)

  end
end