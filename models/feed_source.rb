require "mongoid"
class FeedSource
  include Mongoid::Document
  field :name
  field :url
end