require "spec_helper"

describe SourceLogger do
  class DummyClass
    include SourceLogger
    def getLogger
      logger
    end
  end

  it "should expose a logger only to class which extends it" do
    dummy_logger = "Dummy Logger"
    SourceLogger.logger(dummy_logger)
    DummyClass.new.methods.include?("logger").should be false
    DummyClass.new.getLogger.should == dummy_logger
  end
end
