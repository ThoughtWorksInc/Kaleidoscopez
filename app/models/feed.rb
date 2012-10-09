require "mongoid"

class Feed < Source
  field :url

  def fetch_items()
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
    date = feed_entry.published
    content = Nokogiri::HTML(feed_entry.content || feed_entry.summary)
    img = content.css('img').map{ |i| i['src'] }
    img[0].gsub!(/\?.*/,"") if img[0]
    Item.new({
      :title => feed_entry.title,
      :url => feed_entry.url,
      :author => feed_entry.author,
      :date => date,
      :image => img[0],
      :source => self
    })
  end
end