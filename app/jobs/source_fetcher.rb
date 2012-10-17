class SourceFetcher

  NUMBER_OF_ITEMS = 15

  def self.get_all_items()
    items = Source.all.collect { |source| source.fetch_items(NUMBER_OF_ITEMS) }.flatten.compact

    return if items.length < 10

    Item.delete_all
    items.each { |item| item.save }
  end

end
