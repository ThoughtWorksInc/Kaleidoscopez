class SourceFetcher
  include Singleton
  include SourceLogger
  NUMBER_OF_ITEMS = 5

  def get_all_items()
    logger.info "Getting all Items"
    items = Source.all.collect do |source|
      logger.info("Item fetcher was called for source \"#{source.name}\"")
      begin
        source.fetch_items(NUMBER_OF_ITEMS)
      rescue
        logger.error "Exception Caught while fetching Items of #{source.name}"
        logger.error $!
      end
    end.flatten.compact

    if items.length < 10
      logger.info("Items rejected as Total Number was less than 10")
      return
    end

    Item.delete_all
    items.each { |item| item.save }
    logger.info "#{items.count} Items Saved"
  end

end
