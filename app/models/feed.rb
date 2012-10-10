require "mongoid"
require "fastimage"

class Feed < Source
  field :url
  field :last_fetched_at


  def self.initialize(name,url)
    Feed.create({:name => name, :url => url, :last_fetched_at => Time.now})
  end

  def fetch_items(number_of_items)
    feed = Feedzirra::Feed.fetch_and_parse(url, {:if_modified_since => last_fetched_at})
    self.last_fetched_at = Time.now
    self.save
    create_items(feed.entries.slice(0,number_of_items)) if feed
  end

  private

  MIN_AREA = 10000

  def create_items(feed)
    feed.entries.collect do |feed_entry|
      create_item(feed_entry)
    end
  end

  def create_item(feed_entry)
    img = get_image(feed_entry)

    Item.new({
    :title => feed_entry.title,
    :url => feed_entry.url,
    :author => feed_entry.author,
    :date => feed_entry.published,
    :image => img,
    :source => self
    })
  end


  def get_image(feed_entry)
    content = Nokogiri::HTML(feed_entry.content || feed_entry.summary)
    images = content.css('img').map { |i| i['src'] }
    biggest_image(images)
  end

  def biggest_image(images)
    final_image=nil
    final_image_area=nil

    images.each do |img|
      image_size = FastImage.size(img)
      image_area = image_size[0]*image_size[1] if image_size
      if (image_area && image_area > (final_image_area || MIN_AREA))
        final_image = img
        final_image_area = image_area
      end
    end
    final_image
  end

end