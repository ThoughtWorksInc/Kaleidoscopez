require "feedzirra"
require "mongoid"

class FeedFetcher

    def self.get_feed(url)
      blog = Feedzirra::Feed.fetch_and_parse(url)
      blog.entries.each do |entry|
        Feed.create({:title => entry.title, :url => entry.url, :author => entry.author})
      end
    end

end