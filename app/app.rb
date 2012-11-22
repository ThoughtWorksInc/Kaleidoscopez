require 'sinatra'
require './app/boot'
require 'sass'
require 'erb'

class App < Sinatra::Base

  dir = File.dirname(File.expand_path(__FILE__))
  set :public_folder, "#{dir}/../public"

  get '/' do
    @channels = Channel.all.to_a
    erb :home
  end

  get '/about' do
    send_file 'public/about_kaleidoscopez.html'
  end

  get '/config' do
    @channels = Channel.all.to_a
    erb :config
  end

  get '/about_us' do
    send_file 'public/about_us.html'
  end

  get '/contact_us' do
    send_file 'public/contact_us.html'
    end

  get '/faq' do
    send_file 'public/faq.html'
  end

  get '/:channel_name/edit' do |channel_name|
    @channel = Channel.where(:name => channel_name).to_a[0]
    @sources = Source.all.to_a - @channel.sources
    erb :'channel/edit'
  end

  get '/:channel_name' do |channel|
    send_file 'public/index.html'
  end

  get '/channel/new' do
    send_file 'public/new_channel.html'
  end

  post '/channel/new' do
    Channel.create(:name => params[:name])
    redirect "/#{params[:name]}/edit"
  end

  post '/:channel_name/:source_id' do |channel_name, source_id|
    Channel.where(:name => channel_name).to_a[0].sources << Source.where(:id => source_id).to_a[0]
    nil
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
