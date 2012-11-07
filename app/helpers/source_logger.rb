module SourceLogger
  def logger
    @@logger
  end

  def self.logger(logger)
    logger.formatter=Logger::Formatter.new
    @@logger = logger
  end
  protected :logger
end