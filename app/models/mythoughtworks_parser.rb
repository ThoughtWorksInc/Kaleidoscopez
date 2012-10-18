
class MythoughtworksParser

  def create_item(post, source)
    image = get_image(post)
    Item.new({
      :title => post["subject"],
      :url => post["resources"]["self"]["ref"],
      :author => post["author"]["name"],
      :author_image => post["author"]["resources"]["avatar"]["ref"],
      :date => post["modificationDate"],
      :image => image,
      :source => source
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
    get_image_from_content_url(options, content["resources"]["self"]["ref"], content["type"])
  end

  def get_image_from_content_url(options, content_url, type)
    content = JSON::parse((MyThoughtworks.get(content_url, options)).parsed_response)
    if(type == BLOGPOST)
      images_url = content["resources"]["images"]["ref"]
    else
      images_url = content["message"]["resources"]["images"]["ref"]
    end
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