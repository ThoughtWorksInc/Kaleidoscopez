require 'httparty'

class MyThoughtworks
  include HTTParty
  parser(Proc.new { |body, format| body.gsub(/throw .*;/, '') })
end

BLOGPOST = "post"
DISCUSSION = "discussion"

class MyTWGroupContent < Source
  field :group_name
  field :image_url

  def fetch_items(number_of_items)
    content = JSON::parse(fetch_items_from_group(number_of_items))
    create_items(content) if content["data"]
  end

  private

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
      parser.create_item(post, self, image_url)
    end
  end

end