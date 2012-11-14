require 'sinatra'
require './app/boot'
require 'sass'
require 'erb'

class App < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))
  set :public_folder, "#{dir}/../public"

  get '/' do
    send_file 'public/index.html'
  end

  get '/config' do
    @channels = Channel.all.to_a
    erb :config
  end

  get '/:channel_name/edit' do |channel_name|
    @channel = Channel.where(:name => channel_name).to_a[0]
    erb :'channel/edit'
  end

  get '/:channel_name' do |channel|
    send_file 'public/index.html'
  end

  delete '/:channel_name/:source_id' do |channel_name, source_id|
    Channel.where(:name => channel_name).to_a[0].sources.delete Source.where(:id => source_id).to_a[0]
  end

  get '/news/' do
    items = Item.all.collect {|item| item.attributes.merge("source" => item.source.name)}
    content_type :json
    {:items => items.shuffle!}.to_json
  end

  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}" )
  end

  get '/news/:channel_name' do |name|
    content_type :json
    channel = Channel.where(:name => name).to_a[0]
    items = channel.sources.collect do |source|
      Item.where(:source => source).collect {|item| item.attributes.merge("source" => item.source.name)}
    end.flatten
    {:items => items.shuffle}.to_json
  end

end
