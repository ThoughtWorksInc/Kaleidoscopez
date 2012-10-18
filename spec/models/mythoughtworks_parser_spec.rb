require "spec_helper"

describe MythoughtworksParser do

  before do
    @source = Source.new

    @options = {
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }

    @mythoughtworks_post = {
        "subject" => "My First Post",
        "author" => {
            "name" => "Yahya Poonawala",
            "resources" => {
                "avatar" => {
                    "ref" => "http://yahya.avatar.me"
                }
            }
        },
        "resources" => {
            "self" => {
                "ref" => "http://blogpost.api.url"
            }
        },
        "modificationDate" => "2012-03-02T05:15:32.743+0000"
    }


    @post_content = {
            "resources" => {
                "images" => {
                    "ref" => "content_images_url"
                }
            }
    }

    @images =[{
          "size" => "100",
          "ref" => "image1_url"
        },
        {
          "size" => "200",
          "ref" => "image2_url"
        }
    ]

    @httparty_content = mock(HTTParty)
    @httparty_images = mock(HTTParty)
  end

  it "should authenticate user and return item with nil image when no image exists" do
    MyThoughtworks.should_receive(:get).with("http://blogpost.api.url",@options).and_return(@httparty_content)
    @httparty_content.should_receive(:parsed_response).and_return(@post_content.to_json)
    images = []
    MyThoughtworks.should_receive(:get).with("content_images_url", @options).and_return(@httparty_images)
    @httparty_images.should_receive(:parsed_response).and_return(images.to_json)

    item = MythoughtworksParser.new.create_item(@mythoughtworks_post, @source)

    item.title.should == "My First Post"
    item.url.should == "http://blogpost.api.url"
    item.date.should == "2012-03-02T05:15:32.743+0000"
    item.author.should == "Yahya Poonawala"
    item.image.should == nil
    item.source.should == @source
    item.author_image.should == "http://yahya.avatar.me"
  end

  it "should authenticate user and return item with biggest image" do
    MyThoughtworks.should_receive(:get).with("http://blogpost.api.url",@options).and_return(@httparty_content)
    @httparty_content.should_receive(:parsed_response).and_return(@post_content.to_json)
    MyThoughtworks.should_receive(:get).with("content_images_url", @options).and_return(@httparty_images)
    @httparty_images.should_receive(:parsed_response).and_return(@images.to_json)

    item = MythoughtworksParser.new.create_item(@mythoughtworks_post, @source)

    item.title.should == "My First Post"
    item.url.should == "http://blogpost.api.url"
    item.date.should == "2012-03-02T05:15:32.743+0000"
    item.author.should == "Yahya Poonawala"
    item.image.should == "image2_url"
    item.source.should == @source
    item.author_image.should == "http://yahya.avatar.me"
  end



end