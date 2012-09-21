require 'sinatra/base'
require_relative 'models/feed'

class Radiator < Sinatra::Base
  get '/' do
    "Hello World !"
  end

  get '/all_news' do
    Feed.all.to_a.to_json
  end
end
