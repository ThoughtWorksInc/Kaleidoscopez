require 'mongoid'

class Item
  include Mongoid::Document
  field :title
  field :url
  field :author
  field :date
  field :image
  belongs_to :feed
end