require 'sinatra/base'
require "json"
class Radiator < Sinatra::Base
  get '/' do
    "Hello World !"
  end

  get '/all_news' do
    a = [{"title" => "News 1", "Description" => "Desc of N1"},
         {"title" => "News 2", "Description" => "Desc of N2"},
         {"title" => "News 3", "Description" => "Desc of N3"},
         {"title" => "News 4", "Description" => "Desc of N4"},
         {"title" => "News 5", "Description" => "Desc of N5"},
         {"title" => "News 6", "Description" => "Desc of N6"}]
    a.to_json
  end
end
Radiator.run!
