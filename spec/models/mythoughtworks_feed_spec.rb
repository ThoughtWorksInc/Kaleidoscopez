require "spec_helper"

describe MythoughtworksFeed do

  it {should respond_to :query}

  it "should authenticate user and fetch items" do
    mytw_feed = MythoughtworksFeed.create(:name => "MyTW - Pune Office", :query => "Pune Office News")

    ENV['TW_USERNAME'] = "username"
    ENV['TW_PASSWORD'] = "password"
    options = {
        :query => {
            :q => "Pune+Office+News",
            :type => "post",
            :container => mytw_feed.query,
            :sort => "date",
            :limit => 10
        },
        :basic_auth => {
            :username => "username",
            :password => "password"
        }
    }
    result = search_result
    httparty = mock(HTTParty)
    httparty.should_receive(:parsed_response).and_return(result.to_json)
    MyThoughtworks.stub_chain(:get).with('https://my.thoughtworks.com/api/core/v2/search/content', options).and_return(httparty)

    items = mytw_feed.fetch_items(10)

    items[0].title.should == result[:data][0][:subject]
    items[0].url.should == result[:data][0][:resources][:self][:ref]
    items[0].date.should == result[:data][0][:modificationDate]
    items[0].author.should == result[:data][0][:author][:name]
    items[0].image.should == nil
    items[0].source.should == mytw_feed
    items[0].author_image.should == result[:data][0][:author][:resources][:avatar][:ref]
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
end