
class FeedFetcher

  def self.get_all_feeds()
    Feed.all.each do |feed|
      Item.where(feed: feed).delete
      feed.fetch_feed_entries.each { | item| item.save }
    end
  end

end