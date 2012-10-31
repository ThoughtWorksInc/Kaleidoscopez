class FeedParser

  def create_item(feed_entry, source)
    image_url = get_image(feed_entry)

    Item.new({
                 :title => feed_entry.title,
                 :url => feed_entry.url,
                 :author => feed_entry.author,
                 :date => feed_entry.published,
                 :image => image_url,
                 :summary => parsed_summary(feed_entry),
                 :source => source
             })
  end

  private

  MIN_AREA = 40000

  def get_image(feed_entry)
    summary = Nokogiri::HTML(feed_entry.content || feed_entry.summary)
    images = summary.css('img').map { |i| i['src'] }
    biggest_image(images.compact)

  end

  def biggest_image(images)
    final_image_url = nil
    final_image_area = nil

    images.each do |img|
      image_size = FastImage.size(URI.escape img)
      image_area = image_size[0] * image_size[1] if image_size
      if (image_area && image_area > (final_image_area || MIN_AREA))
        final_image_url = img
        final_image_area = image_area
      end
    end
    final_image_url
  end

  def parsed_summary(feed_entry)
    summary = feed_entry.content || feed_entry.summary
    (summary = summary.gsub(/<.*?>/, "").gsub(/\n/, " ").slice(0,300)) if summary
    (summary = summary + "...") if summary && summary != ""
    summary
  end

end