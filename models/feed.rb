require 'mongoid'

class Feed
  include Mongoid::Document
  field :title
  field :url
  field :author
  belongs_to :feed_source
end