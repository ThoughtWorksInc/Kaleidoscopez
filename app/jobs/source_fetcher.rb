class SourceFetcher


  def self.get_all_items()
    items = Source.all.collect { |source| source.fetch_items }.flatten.compact

    return if (items_are_too_few?(items))

    Item.delete_all
    items.each { |item| item.save }
  end

  private
  def self.items_are_too_few?(items)
    items.length < 10
  end

end
