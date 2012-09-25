require 'sinatra/base'
require_relative 'models/post'

class Radiator < Sinatra::Base
  get '/' do
    send_file 'public/index.html'
  end

  get '/all_news' do
    FeedSource.all.to_a.to_json
  end
end
