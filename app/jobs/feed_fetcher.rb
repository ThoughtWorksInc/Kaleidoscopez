class FeedFetcher

  NUMBER_OF_ITEMS = 15

  def self.get_all_feeds()
    items = Feed.all.collect { |feed| feed.fetch_feed_entries.slice(0,NUMBER_OF_ITEMS) }.flatten.compact

    return if (items_are_too_few?(items))

    Item.delete_all
    items.each { |item| item.save }
  end

  private
  def self.items_are_too_few?(items)
    items.length < 10
  end

end