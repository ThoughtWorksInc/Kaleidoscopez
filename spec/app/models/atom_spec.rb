require "spec_helper"
require_relative "../../../app/models/item"

describe Atom do
  atom = Atom.new
  feedzirra_atom = Feedzirra::Parser::Atom.new


  before(:each) do
    atom.name = "Dummy Source"
    atom.url = "feeds.dummy.com"
    atom.save

    feedzirra_atom.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    feedzirra_atom.entries[0].title = "First Post"
    feedzirra_atom.entries[0].url = "test.url"
    feedzirra_atom.entries[0].author = "Dave Thomas"
    feedzirra_atom.entries[1].title = "Second Post"
    feedzirra_atom.entries[1].url = "test1.url"
    feedzirra_atom.entries[1].author = "Daven Thomas"
  end

  it "should fetch feeds" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(atom.url).and_return(feedzirra_atom)
    atom.fetch_feed_entries()

  end

  it "should create item from the atom feed and add it to the database" do
    item1 = Item.new
    item1.url =  "test.url"
    item1.title = "First Post"
    item1.author = "Dave Thomas"
    item2 = Item.new
    item2.url =  "test1.url"
    item2.title = "Second Post"
    item2.author = "Daven Thomas"

    atom.create_item(feedzirra_atom)

    atom.items[0].title.should == "First Post"
    atom.items[0].url.should == "test.url"
    atom.items[0].author.should == "Dave Thomas"

    atom.items[1].title.should == "Second Post"
    atom.items[1].url.should == "test1.url"
    atom.items[1].author.should == "Daven Thomas"

  end

end