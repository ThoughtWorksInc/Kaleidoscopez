require 'sinatra/base'
require './app/boot'

class App < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))
  set :public_folder, "#{dir}/../public"

  get '/' do
    send_file 'public/index.html'
  end

  get '/all_news' do
    items = Item.all.collect {|item| item.attributes.merge("source" => item.source.name)}
    content_type :json
    {:items => items.shuffle!}.to_json
  end

end
