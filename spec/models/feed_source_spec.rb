require "spec_helper"

describe FeedSource do
  it {should respond_to :name}
  it {should respond_to :url}
  it {should have_many :posts}

  it "should not allow to create feed source object if url is absent" do
    lambda { FeedSource.create!(:name => "First Name") }.should raise_error
  end

  it "should not allow to create feed source object if url is duplicate" do
    FeedSource.create(:url => "First Url")
    lambda { FeedSource.create!(:url => "First Url") }.should raise_error
  end
end