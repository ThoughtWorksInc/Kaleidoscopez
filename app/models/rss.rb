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
      self.items.create({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author})
    end
  end

end