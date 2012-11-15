require 'spec_helper'
require 'rack/test'


def test_json_response(expected_json_response)
  expected_response = JSON.parse expected_json_response
  last_response.should be_ok
  last_response.original_headers["Content-Type"].should include("application/json")
  parsed_response = JSON::parse(last_response.body)
  parsed_response["items"].should =~ expected_response["items"]
end

describe App do
  include Rack::Test::Methods

  def app
    App
  end

  before do
    @feed = Feed.create(:name => "IMDB")
    @item_one = Item.create(:title => "James Bond", :source => @feed)
    @item_two = Item.create(:title => "Rowdy Rathore", :source => @feed)
  end

  it "should fetch and return all the items in a json" do
    expected_json_response = {:items => [
        {
            :_id => @item_one.id,
            :title => @item_one.title,
            :source_id => @item_one.source.id,
            :source => @item_one.source.name
        },
        {
            :_id => @item_two.id,
            :title => @item_two.title,
            :source_id => @item_two.source.id,
            :source => @item_two.source.name
        }
    ]}.to_json

    get '/news/'

    test_json_response(expected_json_response)
  end

  it "should fetch and return all the items of a channel in a json" do

    feed2 = Feed.create(:name => "Feed 2")
    feed3 = Feed.create(:name => "Feed 3")
    item3 = Item.create(:title => "item 3",:source => feed2)
    item4 = Item.create(:title => "item 4", :source => feed3)

    channel = Channel.create(:name => "test", :sources => [@feed,feed2])

    expected_json_response = {:items => [
      {
        :_id => @item_one.id,
        :title => @item_one.title,
        :source_id => @item_one.source.id,
        :source => @item_one.source.name
      },
      {
        :_id => @item_two.id,
        :title => @item_two.title,
        :source_id => @item_two.source.id,
        :source => @item_two.source.name
      },
      {
          :_id =>item3.id,
          :title => item3.title,
          :source_id => item3.source.id,
          :source => item3.source.name
      }
    ]}.to_json

    get '/news/test'
    test_json_response(expected_json_response)

  end

  it "should delete a source from a channel" do
    source1 = Source.create(:name => "s1")
    source2 = Source.create(:name => "s2")
    Channel.create(:name => "c1", :sources => [source1,source2])

    delete '/c1/'+source1.id
    Channel.where(:name => "c1").to_a[0].sources.include?(source1).should be false
  end

  it "should add a source to a channel" do
    source1 = Source.create(:name => "s1")
    source2 = Source.create(:name => "s2")
    source3 = Source.create(:name => "s3")
    Channel.create(:name => "c1", :sources => [source1,source2])

    post '/c1/'+source3.id
    Channel.where(:name => "c1").to_a[0].sources.include?(source3).should be true
  end

  after do
    Feed.delete_all
  end
end
