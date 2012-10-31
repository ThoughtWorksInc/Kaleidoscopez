
class TwitterParser

  def create_item(tweet, source ,source_image)
    img_url = tweet[:media][0][:media_url].gsub!(/\?.*/, "") if tweet[:media][0]
    Item.new({
                 :title => tweet[:text],
                 :date => tweet[:created_at],
                 :author => tweet[:user][:name],
                 :image => img_url,
                 :author_image => tweet[:user][:profile_image_url],
                 :source => source,
                 :source_image => source_image
             })
  end

end