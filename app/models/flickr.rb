require "xmlsimple"
class Flickr < Source
  field :tags

  def fetch_items(max_items)
    flickr_content = XmlSimple.xml_in(HTTParty.get(URI.escape("http://api.flickr.com/services/feeds/photos_public.gne?tags=#{tags}")),{:ForceArray => false})
    flickr_content["entry"].collect do |entry|
      url = img = nil
      entry["link"].each do |link|
        url=link["href"] if(link["rel"]== "alternate")
        img = link["href"] if(link["rel"] == "enclosure")
      end

      Item.new({
          :title => entry["title"],
          :url => url,
          :image => img,
          :author => entry["author"]["name"],
          :author_image => entry["author"]["buddyicon"],
          :date => entry["published"].to_time,
          :source => self
      })
    end
  end
end
