class SourceFetcher
  include Singleton

  NUMBER_OF_ITEMS = 5

  def get_all_items()
    items = Source.all.collect do |source|
      source.fetch_items(NUMBER_OF_ITEMS)
    end.flatten.compact

    return if items.length < 10

    Item.delete_all
    items.each { |item| item.save }
  end

end
