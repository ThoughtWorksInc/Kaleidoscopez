require "mongoid"

class Feed
  include Mongoid::Document
  field :name
  field :url
  has_many :items

  def fetch_feed_entries()
    feed = Feedzirra::Feed.fetch_and_parse(url)
    create_item(feed) if feed
  end

  private

  def create_item(feed)
    Item.delete_all(conditions: {:url => url})
    feed.entries.each do |feed_entry|
      save_item(feed_entry)
    end
  end

end