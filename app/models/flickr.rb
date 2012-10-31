require "xmlsimple"
class Flickr < Source
  field :tags
  field :image_url

  def fetch_items(max_items)
    flickr_content = XmlSimple.xml_in(HTTParty.get(URI.escape("http://api.flickr.com/services/feeds/photos_public.gne?tags=#{tags}&tagmode=any")), {:ForceArray => false})

    parser = FlickrParser.new
    flickr_content["entry"].slice(0, max_items).collect do |entry|
      parser.create_item(entry, self, image_url)
    end
  end

end
