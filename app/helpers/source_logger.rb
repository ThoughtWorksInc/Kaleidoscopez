module SourceLogger
  def logger
    @@logger
  end

  def self.logger(logger)
    @@logger = logger
  end
  protected :logger
end