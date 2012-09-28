require 'sinatra/base'
require_relative 'app/models/item'

class App < Sinatra::Base
  get '/' do
    send_file 'public/index.html'
  end

  get '/all_news' do
    get_all_news
  end

  def get_all_news
    items = Item.all.to_a.shuffle
    sources = {}
    Feed.all.to_a.each do |feed|
      sources[feed._id]=feed.name
    end
    {"feeds"=>items,"sources"=>sources}.to_json
  end
end
