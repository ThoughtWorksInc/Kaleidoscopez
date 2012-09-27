require "feedzirra"
require "./models/feed"

class Rss < Feed

  def fetch_feeds
    atoms = Feedzirra::Feed.fetch_and_parse(url)
  end

end