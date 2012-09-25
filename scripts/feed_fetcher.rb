require "feedzirra"
require "mongoid"
require_relative "../models/feed_source"

class FeedFetcher

  def self.get_feed(feed_source)
    blog = Feedzirra::Post.fetch_and_parse(feed_source.url)
    blog.entries.each do |entry|
      feed_source.feeds.create({:title => entry.title, :url => entry.url, :author => entry.author})
    end
  end

  def self.get_all_feeds()
    FeedSource.all.each do |feed_source|
      get_feed(feed_source)
    end
  end

end