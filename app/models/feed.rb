require "mongoid"
require "fastimage"

class Feed < Source
  field :url

  def fetch_items()
    feed = Feedzirra::Feed.fetch_and_parse(url)
    create_items(feed) if feed
  end

  private

  MIN_AREA = 10000

  def create_items(feed)
    feed.entries.collect do |feed_entry|
      create_item(feed_entry)
    end
  end

  def create_item(feed_entry)
    img = getImage(feed_entry)

    Item.new({
    :title => feed_entry.title,
    :url => feed_entry.url,
    :author => feed_entry.author,
    :date => feed_entry.published,
    :image => img,
    :source => self
    })
  end


  def getImage(feed_entry)
    content = Nokogiri::HTML(feed_entry.content || feed_entry.summary)
    images = content.css('img').map { |i| i['src'] }
    images[0].gsub!(/\?.*/, "") if images[0]
    images.each do |img|
      fast_image_size = FastImage.size(img)
      if(fast_image_size && fast_image_size[0]*fast_image_size[1]>MIN_AREA)
        return img
      end
    end

    nil
  end
end