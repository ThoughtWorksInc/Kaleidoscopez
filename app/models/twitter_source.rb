class TwitterSource < Source
  field :query
  field :image_url

  # Warning: Untested code !!
  Twitter.configure do |config|
    config.consumer_key =  ENV["TWITTER_CUSTOMER_KEY"]
    config.consumer_secret = ENV["TWITTER_CUSTOMER_SECRET"]
    config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
    config.oauth_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]
  end
  # Untested Code Over

  def fetch_items(number_of_items)
    tweets = Twitter.search(query)[:statuses]
    parser = TwitterParser.new
    tweets.slice(0, number_of_items).collect do |tweet|
      parser.create_item(tweet, self , image_url)
    end
  end
end
