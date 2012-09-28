require 'sinatra/base'

class App < Sinatra::Base

  get '/' do
    send_file 'public/index.html'
  end

  get '/all_news' do
    items = Item.all.collect {|item| item.attributes.merge("source" => item.feed.name)}
    content_type :json
    {:items => items.shuffle!}.to_json
  end

end
