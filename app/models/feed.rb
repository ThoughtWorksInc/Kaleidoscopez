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

  def create_item(feed_entry)
    date = feed_entry.published.strftime("%Y-%m-%d")
    content = Nokogiri::HTML(feed_entry.content || feed_entry.summary)
    img = content.css('img').map{ |i| i['src'] }
    Item.new({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date, :image => img[0], :feed => self})
  end
end