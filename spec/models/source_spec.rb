require 'spec_helper'

describe Source do
  it { should respond_to :name}
  it "should include Mongoid::Document" do
    Source.ancestors.include?(Mongoid::Document).should be true
  end
end