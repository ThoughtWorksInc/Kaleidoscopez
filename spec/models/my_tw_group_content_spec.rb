require "spec_helper"

describe MyTWGroupContent do

  it {should respond_to :group_name}

  it "should inherit from Source" do
    MyTWGroupContent.ancestors.should include(Source)
  end

  before do
    @mytw_feed = MyTWGroupContent.create(:name => "MyTW - Pune Office", :group_name => "pune-office")
    ENV['TW_USERNAME'] = "username"
    ENV['TW_PASSWORD'] = "password"

  end

  context "fetch items from a group" do

    before do
      @options = {
          :query => {
              :q => "*a*",
              :type => [BLOGPOST,DISCUSSION],
              :container => @mytw_feed.group_name,
              :sort => "date",
              :limit => 10
          },
          :basic_auth => {
              :username => ENV['TW_USERNAME'],
              :password => ENV['TW_PASSWORD']
          }
      }

      @httparty = mock(HTTParty)

    end

    it "should authenticate user and fetch items" do
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
      @httparty.should_receive(:parsed_response).and_return({"data" => ["first_post", "second_post"]}.to_json)

      MythoughtworksParser.any_instance.stub(:create_item).and_return(Item.new)

      items = @mytw_feed.fetch_items(10)

      items.count.should == 2
    end

    it "should not create items if data is absent in the response" do
      MyThoughtworks.should_receive(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', @options).and_return(@httparty)
      @httparty.should_receive(:parsed_response).and_return({"msg" => "Bad Credentials","code" => 401}.to_json)

      items = @mytw_feed.fetch_items(10)

      items.should be_nil
    end

  end

end