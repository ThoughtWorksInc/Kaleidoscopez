require 'spec_helper'
require 'feed.rb'

describe Feed do
  it {should respond_to :title}
  it {should respond_to :url}
  it {should respond_to :author}
end