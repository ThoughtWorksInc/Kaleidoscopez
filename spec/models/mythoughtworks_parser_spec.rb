require "spec_helper"

describe MythoughtworksParser do

  it "should authenticate user and fetch items" do
    source = Source.new

    item = MythoughtworksParser.new.create_item(mythoughtworks_post, source)

    item.title.should == "My First Post"
    item.url.should == "http://blogpost.api.url"
    item.date.should == "2012-03-02T05:15:32.743+0000"
    item.author.should == "Yahya Poonawala"
    item.image.should == nil
    item.source.should == source
    item.author_image.should == "http://yahya.avatar.me"
  end

  def mythoughtworks_post
    {
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
  end

end