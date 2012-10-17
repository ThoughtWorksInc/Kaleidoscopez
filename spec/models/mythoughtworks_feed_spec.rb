require "spec_helper"

describe MythoughtworksFeed do

  it {should respond_to :query}

  it "should inherit from Source" do
    MythoughtworksFeed.ancestors.should include(Source)
  end

  context "fetch items" do

    before do
      @mytw_feed = MythoughtworksFeed.create(:name => "MyTW - Pune Office", :query => "Pune Office News")

      ENV['TW_USERNAME'] = "username"
      ENV['TW_PASSWORD'] = "password"
      @options = {
          :query => {
              :q => "Pune+Office+News",
              :type => "post",
              :container => @mytw_feed.query,
              :sort => "date",
              :limit => 10
          },
          :basic_auth => {
              :username => "username",
              :password => "password"
          }
      }
      @httparty = mock(HTTParty)
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
    end

    it "should authenticate user and fetch items" do
      @httparty.should_receive(:parsed_response).and_return({"data" => ["first_post", "second_post"]}.to_json)
      MythoughtworksParser.any_instance.should_receive(:create_item).twice.and_return(Item.new)

      items = @mytw_feed.fetch_items(10)

      items.count.should == 2
    end

    it "should not create items if data is absent in the response" do
      @httparty.should_receive(:parsed_response).and_return({"msg" => "Bad Credentials","code" => 401}.to_json)

      items = @mytw_feed.fetch_items(10)

      items.should be_nil
    end

  end

end