class Item
  include Mongoid::Document

  field :title
  field :url
  field :author
  field :date
  field :image
  field :author_image
  field :content

  belongs_to :source
end