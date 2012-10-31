class FlickrParser

  def create_item(entry, source, source_image)
    url = image_url = nil
    entry["link"].each do |link|
      url = link["href"] if (link["rel"]== "alternate")
      image_url = link["href"] if (link["rel"] == "enclosure")
    end

    Item.new({
      :title => entry["title"],
      :url => url,
      :image => image_url,
      :author => entry["author"]["name"],
      :author_image => entry["author"]["buddyicon"],
      :date => entry["published"].to_time,
      :source => source,
      :source_image => source_image
    })
  end

end