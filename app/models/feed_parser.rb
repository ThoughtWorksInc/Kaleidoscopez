require 'imgkit'

class FeedParser

  def create_item(feed_entry, source,source_image)
    image_url = get_image(feed_entry)
    webpage_preview_url = get_webpage_preview(feed_entry) if !image_url

    Item.new({
                 :title => feed_entry.title,
                 :url => feed_entry.url,
                 :author => feed_entry.author,
                 :date => feed_entry.published,
                 :image => image_url,
                 :summary => parsed_summary(feed_entry),
                 :source => source,
                 :source_image => source_image,
                 :webpage_preview => webpage_preview_url,
             })
  end

  private
  MIN_AREA = 10000

  def get_webpage_preview(feed_entry)
    begin
      jpg = IMGKit.new(feed_entry.url,quality: 50,width: 600).to_jpg
    rescue
      jpg = nil
    end
    webpage_preview_to_file(feed_entry, jpg) if jpg
  end

  def webpage_preview_to_file(feed_entry, jpg)
    filename = feed_entry.title[0..4]+feed_entry.published.strftime("%d%m%y%H%M%S")+".jpg"
    file = File.new("public/images/preview/"+filename, "w")
    file.write(jpg)
    file.flush
    file.close
    "/images/preview/"+filename
  end

  def get_image(feed_entry)
    content = Nokogiri::HTML(feed_entry.content || feed_entry.summary)
    images = content.css('img').map { |i| i['src'].gsub(/\?.*/,'') if i['src'] }
    biggest_image(images.compact)

  end

  def biggest_image(images)
    final_image_url = nil
    final_image_area = nil

    images.each do |img|
      image_size = FastImage.size(URI.escape img) if img.length < 256
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
