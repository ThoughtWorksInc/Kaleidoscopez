
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

  def get_image(post)
    options = {
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    get_image_from_content_url(options, post["resources"]["self"]["ref"])
  end

  def get_image_from_content_url(options, content_url)
    content = JSON::parse((MyThoughtworks.get(content_url, options)).parsed_response)
    images = JSON::parse((MyThoughtworks.get(content["resources"]["images"]["ref"], options)).parsed_response)
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