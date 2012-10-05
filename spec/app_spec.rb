require 'spec_helper'
require 'rack/test'

describe App do
  include Rack::Test::Methods

  def app
    App
  end

  it "should fetch and return all the items in a json" do
    feed = Feed.create(:name => "IMDB")
    item_one = Item.create(:title => "James Bond", :feed => feed)
    item_two = Item.create(:title => "Rowdy Rathore", :feed => feed)
    expected_json_response = {:items => [
        {
            :_id => item_one.id,
            :title => item_one.title,
            :feed_id => item_one.feed.id,
            :source => item_one.feed.name
        },
        {
            :_id => item_two.id,
            :title => item_two.title,
            :feed_id => item_two.feed.id,
            :source => item_two.feed.name
        }
    ]}.to_json
    expected_response = JSON::parse(expected_json_response)

    get '/all_news'

    last_response.should be_ok
    last_response.original_headers["Content-Type"].should include("application/json")
    parsed_response = JSON::parse(last_response.body)
    parsed_response["items"].should =~ expected_response["items"]
  end
end
