require 'spec_helper'

describe Item do
  it {should respond_to :title}
  it {should respond_to :url}
  it {should respond_to :author}
  it {should respond_to :date}
  it {should respond_to :source}
  it {should respond_to :image}
  it {should respond_to :author_image}
end