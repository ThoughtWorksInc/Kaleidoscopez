require "spec_helper"

describe MythoughtworksFeed do

  it {should respond_to :query}

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
      result = search_result
      @httparty.should_receive(:parsed_response).and_return(result.to_json)

      items = @mytw_feed.fetch_items(10)

      items.count.should == 1
      items[0].title.should == result[:data][0][:subject]
      items[0].url.should == result[:data][0][:resources][:self][:ref]
      items[0].date.should == result[:data][0][:modificationDate]
      items[0].author.should == result[:data][0][:author][:name]
      items[0].image.should == nil
      items[0].source.should == @mytw_feed
      items[0].author_image.should == result[:data][0][:author][:resources][:avatar][:ref]
    end

    it "should not create items if data is absent in the response" do
      result = error_response
      @httparty.should_receive(:parsed_response).and_return(result.to_json)

      items = @mytw_feed.fetch_items(10)

      items.should be_nil
    end

  end

  def search_result
    {
      :data => [{
        :blogSummary => {
          :name => "Pune-Office News"
        },
        :subject => "My First Post",
        :author => {
          :name => "Yahya Poonawala",
          :resources => {
            :avatar => {
              :ref => "http://yahya.avatar.me"
            }
          }
        },
        :resources => {
          :self => {
            :ref => "http://blogpost.api.url"
          }
        },
        :modificationDate => "2012-03-02T05:15:32.743+0000"
      }]
    }
  end

  def error_response
    {
      :msg => "Bad Credentials",
      :code => 401
    }
  end
end