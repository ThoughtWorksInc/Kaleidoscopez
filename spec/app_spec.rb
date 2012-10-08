require 'spec_helper'
require 'rack/test'

describe App do
  include Rack::Test::Methods

  def app
    App
  end

  it "should fetch and return all the items in a json" do
    feed = Feed.create(:name => "IMDB")
    item_one = Item.create(:title => "James Bond", :source => feed)
    item_two = Item.create(:title => "Rowdy Rathore", :source => feed)
    expected_json_response = {:items => [
        {
            :_id => item_one.id,
            :title => item_one.title,
            :source_id => item_one.source.id,
            :source => item_one.source.name
        },
        {
            :_id => item_two.id,
            :title => item_two.title,
            :source_id => item_two.source.id,
            :source => item_two.source.name
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
