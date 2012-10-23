require "spec_helper"

describe MythoughtworksFeed do

  it {should respond_to :group_name}

  it "should inherit from Source" do
    MythoughtworksFeed.ancestors.should include(Source)
  end

  before do
    @mytw_feed = MythoughtworksFeed.create(:name => "MyTW - Pune Office", :group_name => "pune-office")
    ENV['TW_USERNAME'] = "username"
    ENV['TW_PASSWORD'] = "password"

  end

  context "fetch items from a group" do

    before do
      @options = {
          :query => {
              :q => "a",
              :type => BLOGPOST,
              :type => DISCUSSION,
              :container => @mytw_feed.group_name,
              :sort => "date",
              :limit => 10
          },
          :basic_auth => {
              :username => ENV['TW_USERNAME'],
              :password => ENV['TW_PASSWORD']
          }
      }

      @options_tag = {
          :query => {
              :q => TAG,
              :type => BLOGPOST,
              :type => DISCUSSION,
              :sort => "date",
              :limit => 10
          },
          :basic_auth => {
              :username => ENV['TW_USERNAME'],
              :password => ENV['TW_PASSWORD']
          }
      }

      @httparty = mock(HTTParty)
      @httparty_tag = mock(HTTParty)
    end

    it "should authenticate user and fetch items if both contents present" do
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
      @httparty.should_receive(:parsed_response).and_return({"data" => ["first_post", "second_post"]}.to_json)
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options_tag).and_return(@httparty_tag)
      @httparty_tag.should_receive(:parsed_response).and_return({"data" => ["third_post", "fourth_post","fifth_post"]}.to_json)

      MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

      items = @mytw_feed.fetch_items(10)

      items.count.should == 5
    end

    it "should not create items if data is absent in the response" do
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
      @httparty.should_receive(:parsed_response).and_return({"msg" => "Bad Credentials","code" => 401}.to_json)
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options_tag).and_return(@httparty_tag)
      @httparty_tag.should_receive(:parsed_response).and_return({"msg" => "Bad Credentials","code" => 401}.to_json)

      items = @mytw_feed.fetch_items(10)

      items.should be_nil
    end

    it "should create items of group-content only if response in group-content present but tag-content absent" do
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
      @httparty.should_receive(:parsed_response).and_return({"data" => ["first_post", "second_post"]}.to_json)
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options_tag).and_return(@httparty_tag)
      @httparty_tag.should_receive(:parsed_response).and_return({"msg" => "Bad Credentials","code" => 401}.to_json)

      MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

      items = @mytw_feed.fetch_items(10)
      items.count.should == 2
    end

    it "should create items of tag-content only if response in group-content absent but tag-content present" do
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
      @httparty.should_receive(:parsed_response).and_return({"msg" => "Bad Credentials","code" => 401}.to_json)
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options_tag).and_return(@httparty_tag)
      @httparty_tag.should_receive(:parsed_response).and_return({"data" => ["first_post", "second_post", "third_post"]}.to_json)

      MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

      items = @mytw_feed.fetch_items(10)
      items.count.should == 3
    end

  end

end