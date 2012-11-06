
class MyTwParser

  def create_item(data, source , source_image)
    image = get_image(data)
    summary = parsed_summary(data)
    Item.new({
      :title => data["subject"],
      :url => data["resources"]["self"]["ref"],
      :author => data["author"]["name"],
      :author_image => data["author"]["resources"]["avatar"]["ref"],
      :date => data["modificationDate"],
      :image => image,
      :summary => summary,
      :source => source,
      :source_image => source_image
    })
  end

  private

  def get_image(data)
    options = {
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    if(data["type"])
      get_image_from_content_url(options, data["resources"]["self"]["ref"], data["type"])
    else
      images_url = data["resources"]["images"]["ref"]
      retrieve_image(images_url, options)
    end
  end

  def get_image_from_content_url(options, content_url, type)
    content = JSON::parse((MyThoughtworks.get(content_url, options)).parsed_response)
    if(type == BLOGPOST)
      images_url = content["resources"]["images"]["ref"]
    elsif(type == DISCUSSION)
      images_url = content["message"]["resources"]["images"]["ref"]
    end
    retrieve_image(images_url, options)
  end

  def retrieve_image(images_url, options)
    images = JSON::parse((MyThoughtworks.get(images_url, options)).parsed_response)
    get_biggest_image(images)
  end

  def get_biggest_image(images)
    biggest_image_size = 0
    biggest_image_url = nil
    images.each do |image|
       if((image["size"]).to_i > biggest_image_size)
         biggest_image_size = image["size"].to_i
         biggest_image_url = image["ref"]
       end
    end
    biggest_image_url
  end

  def parsed_summary(data)
    if(data["type"])
      summary = data["contentSummary"]
    else
      summary = data["content"]["text"]
    end
    (summary = summary.gsub(/<.*?>/, "").gsub(/\n/, " ").slice(0,300)) if summary
    (summary = summary + "...") if summary && summary != ""
    summary
  end

end