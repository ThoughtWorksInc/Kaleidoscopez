require 'httparty'

class MyThoughtworks
  include HTTParty
  parser(Proc.new { |body, format| body.gsub(/throw .*;/, '') })
end

class MythoughtworksFeed < Source
  field :query

  def fetch_items(number_of_items)
    options = {
        :query => {
            :q => query.split(/[-\s]+/).join("+"),
            :type => "post",
            :container => query,
            :sort => "date",
            :limit => number_of_items
        },
        :basic_auth => {
            :username => ENV['TW_USERNAME'],
            :password => ENV['TW_PASSWORD']
        }
    }
    response = MyThoughtworks.get('https://my.thoughtworks.com/api/core/v2/search/content', options).parsed_response
    create_items(JSON::parse(response)) if response["data"]
  end

  def create_items(response)
    parser = MythoughtworksParser.new
    response["data"].collect do |post|
      parser.create_item(post, self)
    end
  end

end