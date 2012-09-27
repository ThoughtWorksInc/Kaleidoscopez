require "feedzirra"
require "mongoid"
require_relative "../app/models/feed"

class FeedFetcher

  def self.get_all_feeds()
    Feed.all.each do |feed|
      feed.fetch_feeds()
    end
  end

end