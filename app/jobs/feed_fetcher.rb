
class FeedFetcher

  def self.get_all_feeds()
    items = Feed.all.collect { |feed| feed.fetch_feed_entries }
    items.flatten!
    return if (items.length < 10)

    Item.delete_all
    items.each { |item| item.save }
  end

end