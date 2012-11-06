class Source
  include SourceLogger
  include Mongoid::Document
  field :name
end