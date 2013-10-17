require "mongoid"
require "fastimage"

class Feed < Source
  field :url
  field :image_url
  field :last_fetched_at
  field :has_summary ,type:Boolean, default: true

  def self.create(opts)
    super({:has_summary => true, :last_fetched_at => 1.month.ago}.merge opts)
  end

  def fetch_items(number_of_items)
    feed = Feedzirra::Feed.fetch_and_parse(url,{:if_modified_since => last_fetched_at})
    update_attributes(:last_fetched_at => Time.now)
    create_items(feed.entries.slice(0, number_of_items)) if feed
  end

  private

  def create_items(feed)
    feed_parser = FeedParser.new
    feed.entries.collect do |feed_entry|
      feed_parser.create_item(feed_entry, self, image_url)
    end
  end

end
