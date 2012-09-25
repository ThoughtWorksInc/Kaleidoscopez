require 'spec_helper'

describe Post do
  it {should respond_to :title}
  it {should respond_to :url}
  it {should respond_to :author}
  it {should respond_to :feed_source}
  it {should belong_to :feed_source}
end