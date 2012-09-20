require 'sinatra'
require "json"

get '/' do
  "Hello World !"
end

get '/all_news' do
  a = [{"title" => "News 1", "Description" => "Desc of N1"},{"title" => "News 2", "Description" => "Desc of N2"}]
  a.to_json
end
