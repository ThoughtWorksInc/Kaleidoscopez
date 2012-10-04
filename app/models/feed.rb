require "mongoid"

class Feed
  include Mongoid::Document

  field :name
  field :url
  has_many :items

  def fetch_feed_entries()
    feed = Feedzirra::Feed.fetch_and_parse(url)
    create_items(feed) if feed
  end

  private

  def create_items(feed)
    feed.entries.collect do |feed_entry|
      create_item(feed_entry)
    end
  end

end