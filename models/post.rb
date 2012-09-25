require 'mongoid'

class Post
  include Mongoid::Document
  field :title
  field :url
  field :author

  belongs_to :feed_source
end