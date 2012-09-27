require "feedzirra"
require "mongoid"
require_relative "../models/feed"

class FeedFetcher

  def self.get_feed(feed)
    blog = Feedzirra::Feed.fetch_and_parse(feed.url)
    if(!blog.entries.nil?)
      Item.delete_all(conditions: {:url => feed.url})
      blog.entries.each do |entry|
        feed.items.create({:title => entry.title, :url => entry.url, :author => entry.author})
      end
    end
  end

  def self.get_all_feeds()
    Feed.all.each do |feed|
      get_feed(feed)
    end
  end

end