require "spec_helper"

describe TwitterParser do
  before do
    @tweet={
        :created_at => Time.parse("Fri Oct 05 17:15:12 +0000 2012"),
        :text => "Tweet text",
        :media => [{
                       :media_url => "media_url?params"
                   }],
        :user => {
            :name => "user name",
            :profile_image_url =>"img_url"
        }
    }
    @source = Source.new
  end

  it "should create item object when image_url is present" do
    item = TwitterParser.new.create_item(@tweet, @source)

    item.title.should == "Tweet text"
    item.date.should == Time.parse("Fri Oct 05 17:15:12 +0000 2012")
    item.author.should == "user name"
    item.image.should == "media_url"
    item.author_image.should == "img_url"
    item.source.should == @source

  end

  it "should create item object when image_url is not present" do
    tweet = @tweet
    tweet[:media] = []
    item = TwitterParser.new.create_item(@tweet, @source)

    item.title.should == "Tweet text"
    item.date.should == Time.parse("Fri Oct 05 17:15:12 +0000 2012")
    item.author.should == "user name"
    item.image.should == nil
    item.author_image.should == "img_url"
    item.source.should == @source

  end
  

end