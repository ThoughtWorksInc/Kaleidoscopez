require './app/models/feed'
require "feedzirra"

class Atom < Feed

  def fetch_feeds
    atoms = Feedzirra::Feed.fetch_and_parse(url)
  end

end