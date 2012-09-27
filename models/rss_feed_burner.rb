require "feedzirra"
require './models/feed'

class RssFeedBurner < Feed

  def fetch_feeds
    atoms = Feedzirra::Feed.fetch_and_parse(url)
  end


end