require 'sinatra/base'
require_relative 'models/item'

class Radiator < Sinatra::Base
  get '/' do
    send_file 'public/index.html'
  end


  get '/all_news' do
    get_all_news
  end

  def get_all_news
    feeds = Item.all.to_a.shuffle
    sources = {}
    Feed.all.to_a.each do |feed_source|
      sources[feed_source._id]=feed_source.name
    end
    {"feeds"=>feeds,"sources"=>sources}.to_json
  end
end
