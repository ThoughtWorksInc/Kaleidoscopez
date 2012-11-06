require "spec_helper"

describe MyTwParser do

  before do
    @source = Source.new
    @source_image = "source_image_url"
    @options = {
      :basic_auth => {
          :username => ENV['TW_USERNAME'],
          :password => ENV['TW_PASSWORD']
      }
    }

    @images =[
      {
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

  context "myThoughtworks blogposts" do

    before do
      @mythoughtworks_post = {
          "type" => "post",
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
          "contentSummary" => "This is the first post",
          "modificationDate" => "2012-03-02T05:15:32.743+0000"
      }

      @post_content = {
          "resources" => {
              "images" => {
                  "ref" => "content_images_url"
              }
          }
      }

    end

    it "should authenticate user and return item with nil image when no image exists for blogpost" do
      MyThoughtworks.should_receive(:get).with("http://blogpost.api.url",@options).and_return(@httparty_content)
      @httparty_content.should_receive(:parsed_response).and_return(@post_content.to_json)
      images = []
      MyThoughtworks.should_receive(:get).with("content_images_url", @options).and_return(@httparty_images)
      @httparty_images.should_receive(:parsed_response).and_return(images.to_json)

      item = MyTwParser.new.create_item(@mythoughtworks_post, @source , @source_image)

      item.title.should == "My First Post"
      item.url.should == "http://blogpost.api.url"
      item.date.should == "2012-03-02T05:15:32.743+0000"
      item.author.should == "Yahya Poonawala"
      item.summary.should == "This is the first post..."
      item.image.should == nil
      item.source.should == @source
      item.author_image.should == "http://yahya.avatar.me"
    end

    it "should authenticate user and return item with biggest image for blogpost" do
      MyThoughtworks.should_receive(:get).with("http://blogpost.api.url",@options).and_return(@httparty_content)
      @httparty_content.should_receive(:parsed_response).and_return(@post_content.to_json)
      MyThoughtworks.should_receive(:get).with("content_images_url", @options).and_return(@httparty_images)
      @httparty_images.should_receive(:parsed_response).and_return(@images.to_json)

      item = MyTwParser.new.create_item(@mythoughtworks_post, @source , @source_image)

      item.title.should == "My First Post"
      item.url.should == "http://blogpost.api.url"
      item.date.should == "2012-03-02T05:15:32.743+0000"
      item.author.should == "Yahya Poonawala"
      item.image.should == "image2_url"
      item.source.should == @source
      item.author_image.should == "http://yahya.avatar.me"
    end

  end

  context "myThoughtworks discussions" do

    before do

      @mythoughtworks_discussion = {
          "type" => "discussion",
          "subject" => "My First Discussion",
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
          "contentSummary" => "This is the first discussion",
          "modificationDate" => "2012-03-02T05:15:32.743+0000"
      }

      @discussion_content ={
          "message" => {
              "resources" => {
                  "images" => {
                      "ref" => "content_images_url"
                  }
              }
          }
      }

    end

    it "should authenticate user and return item with nil image when no image exists for discussion" do
      MyThoughtworks.should_receive(:get).with("http://blogpost.api.url",@options).and_return(@httparty_content)
      @httparty_content.should_receive(:parsed_response).and_return(@discussion_content.to_json)
      images = []
      MyThoughtworks.should_receive(:get).with("content_images_url", @options).and_return(@httparty_images)
      @httparty_images.should_receive(:parsed_response).and_return(images.to_json)

      item = MyTwParser.new.create_item(@mythoughtworks_discussion, @source , @source_image)

      item.title.should == "My First Discussion"
      item.url.should == "http://blogpost.api.url"
      item.date.should == "2012-03-02T05:15:32.743+0000"
      item.author.should == "Yahya Poonawala"
      item.image.should == nil
      item.source.should == @source
      item.summary.should == "This is the first discussion..."
      item.author_image.should == "http://yahya.avatar.me"
    end

    it "should authenticate user and return item with biggest image for discussion" do
      MyThoughtworks.should_receive(:get).with("http://blogpost.api.url",@options).and_return(@httparty_content)
      @httparty_content.should_receive(:parsed_response).and_return(@discussion_content.to_json)
      MyThoughtworks.should_receive(:get).with("content_images_url", @options).and_return(@httparty_images)
      @httparty_images.should_receive(:parsed_response).and_return(@images.to_json)

      item = MyTwParser.new.create_item(@mythoughtworks_discussion, @source , @source_image)

      item.title.should == "My First Discussion"
      item.url.should == "http://blogpost.api.url"
      item.date.should == "2012-03-02T05:15:32.743+0000"
      item.author.should == "Yahya Poonawala"
      item.image.should == "image2_url"
      item.source.should == @source
      item.author_image.should == "http://yahya.avatar.me"
    end

  end

end