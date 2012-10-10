class TwitterSource < Source
  field :query

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
    tweets.slice(0,number_of_items).collect do |tweet|
        img_url = tweet[:media][0][:media_url].gsub!(/\?.*/,"") if tweet[:media][0]
        Item.new({
          :title => tweet[:text],
          :date => tweet[:created_at],
          :author => tweet[:user][:name],
          :image => img_url,
          :author_image => tweet[:user][:profile_image_url],
          :source => self
        })
    end
  end
end
