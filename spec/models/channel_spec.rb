require "rspec"

describe Channel do
  it "should be a Mongoid Document" do
    Channel.ancestors.include?(Mongoid::Document).should be true
  end
  it {should respond_to :name}
  it {should respond_to :sources }
end