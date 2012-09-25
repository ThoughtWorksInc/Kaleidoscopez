require "mongoid"
class FeedSource
  include Mongoid::Document
  field :name
  field :url
  has_many :feeds
end