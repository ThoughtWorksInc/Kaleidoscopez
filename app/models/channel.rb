class Channel
  include Mongoid::Document
  field :name
  has_and_belongs_to_many :sources, inverse_of: nil
end