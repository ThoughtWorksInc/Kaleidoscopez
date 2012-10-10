class SourceFetcher

  NUMBER_OF_ITEMS = 15

  def self.get_all_items()
    items = Source.all.collect { |source| source.fetch_items(NUMBER_OF_ITEMS) }.flatten.compact

    return if (items_are_too_few?(items))

    Item.delete_all
    items.each { |item| item.save }
  end

  private
  def self.items_are_too_few?(items)
    items.length < 10
  end

end
