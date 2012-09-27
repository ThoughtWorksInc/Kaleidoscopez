require 'mongoid'

class Item
  include Mongoid::Document
  field :title
  field :url
  field :author
  belongs_to :feed
end