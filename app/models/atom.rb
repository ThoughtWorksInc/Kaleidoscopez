require './app/models/feed'
require "feedzirra"

class Atom < Feed

  def create_item(feed_entry)
    date = feed_entry.published.strftime("%Y-%m-%d")
    content = Nokogiri::HTML(feed_entry.content)
    img = content.css('img').map{ |i| i['src'] }
    Item.new({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date, :image => img[0], :feed => self})
  end

end