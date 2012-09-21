require 'mongoid'

class Feed
  include Mongoid::Document
  field :title
  field :url
  field :author

end