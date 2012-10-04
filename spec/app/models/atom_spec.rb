require "spec_helper"
require_relative "../../../app/models/item"

describe Atom do

  before(:each) do
    @atom = Atom.new
    @feedzirra_atom = Feedzirra::Parser::Atom.new
    @atom.name = "Dummy Source"
    @atom.url = "feeds.dummy.com"
    @atom.save

    @feedzirra_atom.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    @feedzirra_atom.entries[0].title = "First Post"
    @feedzirra_atom.entries[0].url = "test.url"
    @feedzirra_atom.entries[0].author = "Dave Thomas"
    @feedzirra_atom.entries[0].published = "2012-09-29 06:03:48 UTC"
    @feedzirra_atom.entries[0].content = "<div><br /></div><div>(Side note: test)<br /><div><br /></div><div>test1</div><div><br /></div><div>Because we <i>care just enough</i> to feed our kids!</div><div><br /></div><div>test2</div></div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test2.com' alt='' /></div>"
    @feedzirra_atom.entries[1].title = "Second Post"
    @feedzirra_atom.entries[1].url = "test1.url"
    @feedzirra_atom.entries[1].author = "Daven Thomas"
    @feedzirra_atom.entries[1].published = "2013-09-29 06:03:48 UTC"
    @feedzirra_atom.entries[1].content = "<div><br /></div><div>(Side note: test)<br /><div><br /></div><div>test1</div><div><br /></div><div>Because we <i>care just enough</i> to feed our kids!</div><div><br /></div><div>test2</div></div><div class=\"blogger-post-footer\"><img width='1' height='1' src='http://test.com' alt='' /></div>"
  end

  it "should fetch feeds as items" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(@atom.url).and_return(@feedzirra_atom)
    items = @atom.fetch_feed_entries()

    items[0].title.should == "First Post"
    items[0].url.should == "test.url"
    items[0].author.should == "Dave Thomas"
    items[0].date.should == "2012-09-29"
    items[0].image.should == "http://test2.com"

    items[1].title.should == "Second Post"
    items[1].url.should == "test1.url"
    items[1].author.should == "Daven Thomas"
    items[1].date.should == "2013-09-29"
    items[1].image.should == "http://test.com"
  end

end