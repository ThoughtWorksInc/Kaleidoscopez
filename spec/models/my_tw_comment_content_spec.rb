require "spec_helper"

describe MyTWCommentContent do

  it "should inherit from Source" do
    MyTWGroupContent.ancestors.should include(Source)
  end

  it {should respond_to :comment_tag}

  before do
    ENV['TW_USERNAME'] = "username"
    ENV['TW_PASSWORD'] = "password"

    @options = {
      :query => {
          :q => "dashboard",
          :sort => "date",
          :limit => 5
      },
      :basic_auth => {
          :username => "username",
          :password => "password"
      }
    }

    @credentials ={
        :basic_auth => {
            :username => "username",
            :password => "password"
        }
    }

    @content_with_tag_1 = {
        "type" => "comment",
        "resources" => {
            "self" => {
                "ref" => "comment_url_1"
            }
        }
    }

    @content_with_tag_2 = {
        "type" => "comment",
        "resources" => {
            "self" => {
                "ref" => "comment_url_2"
            }
        }
    }

    @contents_with_tag ={
        "data" => [@content_with_tag_1, @content_with_tag_2]
    }

    @comment1 = {
        "resources" => {
            "parent" => {
                "ref" => "content_url_1"
            }
        }
    }

    @comment2 = {
        "resources" => {
            "parent" => {
                "ref" => "content_url_2"
            }
        }
    }

    @httparty = mock(HTTParty)
    @httparty_comment1 = mock(HTTParty)
    @httparty_comment2 = mock(HTTParty)
    @httparty_content1 = mock(HTTParty)
    @httparty_content2 = mock(HTTParty)
    @my_tw_comment_content = MyTWCommentContent.new(:comment_tag => "dashboard")
  end

  it "should authenticate user and fetch content when content is present" do
    MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
    @httparty.should_receive(:parsed_response).and_return(@contents_with_tag.to_json)

    MyThoughtworks.should_receive(:get).with("comment_url_1", @credentials).and_return(@httparty_comment1)
    @httparty_comment1.should_receive(:parsed_response).and_return(@comment1.to_json)
    MyThoughtworks.should_receive(:get).with("comment_url_2", @credentials).and_return(@httparty_comment2)
    @httparty_comment2.should_receive(:parsed_response).and_return(@comment2.to_json)

    MyThoughtworks.should_receive(:get).with("content_url_1", @credentials).and_return(@httparty_content1)
    @httparty_content1.should_receive(:parsed_response).and_return({"name" => "sonia"}.to_json)
    MyThoughtworks.should_receive(:get).with("content_url_2", @credentials).and_return(@httparty_content2)
    @httparty_content2.should_receive(:parsed_response).and_return({"name" => "yahya"}.to_json)

    MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

    items = @my_tw_comment_content.fetch_items(5)

    items.count.should == 2

  end

  it "should return no items if no comments with given tag" do
    MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
    @httparty.should_receive(:parsed_response).and_return({"data" => []}.to_json)
    MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

    items = @my_tw_comment_content.fetch_items(5)

    items.count.should == 0

    end

  it "should return no items if credentials are incorrect" do
    MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
    @httparty.should_receive(:parsed_response).and_return({"msg" => "Bad credentials", "code" => 401}.to_json)
    MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

    items = @my_tw_comment_content.fetch_items(5)

    items.count.should == 0

  end

end