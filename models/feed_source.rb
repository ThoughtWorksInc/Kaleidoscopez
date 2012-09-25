require "mongoid"
class FeedSource
  include Mongoid::Document
  field :name
  field :url
  has_many :posts

  validates :url, uniqueness: true, presence: true
end