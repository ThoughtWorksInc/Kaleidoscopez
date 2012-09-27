require "feedzirra"
require "./app/models/feed"

class Rss < Feed

  def fetch_feeds
    atoms = Feedzirra::Feed.fetch_and_parse(url)
  end

end