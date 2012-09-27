require "mongoid"

class Feed
  include Mongoid::Document
  field :name
  field :url
  has_many :items
end