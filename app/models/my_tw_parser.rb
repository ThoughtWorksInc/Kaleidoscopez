
class MyTwParser

  def create_item(post, source , source_image)
    image = get_image(post)
    Item.new({
      :title => post["subject"],
      :url => post["resources"]["self"]["ref"],
      :author => post["author"]["name"],
      :author_image => post["author"]["resources"]["avatar"]["ref"],
      :date => post["modificationDate"],
      :image => image,
      :source => source,
      :source_image => source_image
    })
  end

  private

  def get_image(content)
    options = {
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    if(content["type"])
      get_image_from_content_url(options, content["resources"]["self"]["ref"], content["type"])
    else
      images_url = content["resources"]["images"]["ref"]
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

end