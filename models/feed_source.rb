require "mongoid"
class FeedSource
  include Mongoid::Document
  field :name
  field :url
  embeds_many :feeds
end