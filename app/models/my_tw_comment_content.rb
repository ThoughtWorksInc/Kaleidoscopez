require 'httparty'

class MyThoughtworks
  include HTTParty
  parser(Proc.new { |body, format| body.gsub(/throw .*;/, '') })
end

class MyTWCommentContent < Source

  field  :comment_tag
  field  :image_url

  def fetch_items(number_of_items)
    options = {
        :query => {
            :q => comment_tag,
            :sort => "date",
            :limit => number_of_items
        },
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    content = JSON::parse(MyThoughtworks.get('https://my.thoughtworks.com/api/core/v2/search/content', options).parsed_response)
    fetch_content_with_tag(content)
  end

  private

  def fetch_content_with_tag(content)
    parser = MythoughtworksParser.new
    items = Array.new
    if(content["data"])
       content["data"].each do |content|
         item = create_item(content, parser)
         items.append(item)
       end
    end
    items
  end

  def create_item(content, parser)
    if (content["type"] == "comment")
      raw_content = fetch_content_from_comment(content["resources"]["self"]["ref"])
      item = parser.create_item(raw_content, self , image_url)
    elsif (content["type"] == DISCUSSION)
      item = parser.create_item(content, self , image_url)
    else
      item = nil
    end
    item
  end

  def fetch_content_from_comment(comment_url)
    options = {
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    comment = JSON::parse(MyThoughtworks.get(comment_url, options).parsed_response)
    fetch_comment_from_url(comment["resources"]["parent"]["ref"])

  end

  def fetch_comment_from_url(content_url)
    options = {
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    JSON::parse(MyThoughtworks.get(content_url, options).parsed_response)

  end

end