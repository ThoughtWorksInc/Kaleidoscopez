require "feedzirra"
require './app/models/feed'

class RssFeedBurner < Feed

  def fetch_feed_entries
    fz_feedburner = Feedzirra::Feed.fetch_and_parse(url)
    create_item(fz_feedburner)
  end

  def create_item(fz_feedburner)
    Item.delete_all(conditions: {:url => url})
    fz_feedburner.entries.each do |feed_entry|
      date = feed_entry.published.strftime("%Y-%m-%d")
      self.items.create({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date})
    end
  end


end