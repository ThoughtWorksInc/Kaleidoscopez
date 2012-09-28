require './app/models/feed'
require "feedzirra"

class Atom < Feed

  def fetch_feed_entries
    fz_atom = Feedzirra::Feed.fetch_and_parse(url)
    create_item(fz_atom)
  end

  def create_item(fz_atom)
    Item.delete_all(conditions: {:url => url})
    fz_atom.entries.each do |feed_entry|
      date = feed_entry.published.strftime("%Y-%m-%d")
      self.items.create({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date})
    end
  end

end