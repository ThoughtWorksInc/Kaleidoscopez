class MythoughtworksParser

  def create_item(post, source)
    Item.new({
      :title => post["subject"],
      :url => post["resources"]["self"]["ref"],
      :author => post["author"]["name"],
      :author_image => post["author"]["resources"]["avatar"]["ref"],
      :date => post["modificationDate"],
      :image => nil,
      :source => source
    })
  end

end