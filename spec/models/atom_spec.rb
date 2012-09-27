require "spec_helper"

describe Atom do

  it "should fetch feeds" do
    atom = Atom.new
    atom.name = "Dummy Source"
    atom.url = "feeds.dummy.com"
    feedzirra_atom = Feedzirra::Parser::Atom.new
    feedzirra_atom.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    feedzirra_atom.entries[0].title = "First Post"
    feedzirra_atom.entries[0].url = "test.url"
    feedzirra_atom.entries[0].author = "Dave Thomas"
    feedzirra_atom.entries[1].title = "Second Post"
    feedzirra_atom.entries[1].url = "test1.url"
    feedzirra_atom.entries[1].author = "Daven Thomas"

    Feedzirra::Feed.should_receive(:fetch_and_parse).with(atom.url).and_return(feedzirra_atom)

    atom.fetch_feeds()

  end
end