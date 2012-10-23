require 'httparty'

class MyThoughtworks
  include HTTParty
  parser(Proc.new { |body, format| body.gsub(/throw .*;/, '') })
end

BLOGPOST = "post"
DISCUSSION = "discussion"

TAG = "PuneDashboard"

class MythoughtworksFeed < Source
  field :group_name

  def fetch_items(number_of_items)
    content_from_group = JSON::parse(fetch_items_from_group(number_of_items))
    content_with_tag = JSON::parse(fetch_items_with_tag(number_of_items))
    content = merge_both_contents(content_with_tag, content_from_group)
    create_items(content) if content["data"]
  end

  private

  def merge_both_contents(content1, content2)
    content = Hash.new
    if (content1["data"] && content2["data"])
      content["data"] = content1["data"] + content2["data"]
    elsif (content1["data"])
      content["data"] = content1["data"]
    elsif (content2["data"])
      content["data"] = content2["data"]
    end
    return content
  end

  def fetch_items_with_tag(number_of_items)
    options = {
        :query => {
            :q => TAG,
            :type => BLOGPOST,
            :type => DISCUSSION,
            :sort => "date",
            :limit => number_of_items
        },
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    MyThoughtworks.get('https://my.thoughtworks.com/api/core/v2/search/content', options).parsed_response
  end

  def fetch_items_from_group(number_of_items)
    options = {
        :query => {
            :q => "a", #"a" has been used as a generic search query to fetch all results assuming all posts contain "a"
            :type => BLOGPOST,
            :type => DISCUSSION,
            :container => group_name,
            :sort => "date",
            :limit => number_of_items
        },
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    MyThoughtworks.get('https://my.thoughtworks.com/api/core/v2/search/content', options).parsed_response
  end

  def create_items(response)
    parser = MythoughtworksParser.new
    response["data"].collect do |post|
      parser.create_item(post, self)
    end
  end

end