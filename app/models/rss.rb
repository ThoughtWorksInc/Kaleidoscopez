require "feedzirra"
require "./app/models/feed"

class Rss < Feed

  def create_item(feed_entry)
    date = feed_entry.published.strftime("%Y-%m-%d")
    summary = Nokogiri::HTML(feed_entry.summary)
    img = summary.css('img').map{ |i| i['src'] }
    Item.new({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date , :image => img[0],:feed => self})
  end

end