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
    feedzirra_atom.entries[0].published = "2012-09-29 06:03:48 UTC"
    feedzirra_atom.entries[1].title = "Second Post"
    feedzirra_atom.entries[1].url = "test1.url"
    feedzirra_atom.entries[1].author = "Daven Thomas"
    feedzirra_atom.entries[1].published = "2013-09-29 06:03:48 UTC"
  end

  it "should fetch feeds" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(atom.url).and_return(feedzirra_atom)
    atom.fetch_feed_entries()

  end

  it "should create item from the atom feed and add it to the database" do

    atom.create_item(feedzirra_atom)

    atom.items[0].title.should == "First Post"
    atom.items[0].url.should == "test.url"
    atom.items[0].author.should == "Dave Thomas"
    atom.items[0].date.should == "2012-09-29"

    atom.items[1].title.should == "Second Post"
    atom.items[1].url.should == "test1.url"
    atom.items[1].author.should == "Daven Thomas"
    atom.items[1].date.should == "2013-09-29"

  end

end