require "spec_helper"

describe Feed do
  it {should respond_to :name}
  it {should respond_to :url}
  it {should respond_to :items}

end