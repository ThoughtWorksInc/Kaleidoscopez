require "feedzirra"
require "./app/models/feed"

class Rss < Feed

  def fetch_feed_entries
    fz_rss = Feedzirra::Feed.fetch_and_parse(url)
    create_item(fz_rss)
  end

  def create_item(fz_rss)
    Item.delete_all(conditions: {:url => url})
    fz_rss.entries.each do |feed_entry|
      date = nil
      summary = Nokogiri::HTML(feed_entry.summary)
      img = summary.css('img').map{ |i| i['src'] }
      self.items.create({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date , :image => img[0]})
    end
  end

end