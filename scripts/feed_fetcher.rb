require "feedzirra"
require "mongoid"
require_relative "../app/models/feed"

class FeedFetcher

  def self.get_all_feeds()
    Feed.all.each do |feed|
      feed.fetch_feed_entries()
    end
  end

end