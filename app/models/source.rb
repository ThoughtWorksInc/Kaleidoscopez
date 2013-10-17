class Source
  include SourceLogger
  include Mongoid::Document
  field :name

  def self.inherited(type)
    @types ||= []
    @types << type
  end

  def self.types
    @types ||= []
  end

end
