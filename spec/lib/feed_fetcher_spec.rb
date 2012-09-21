require 'spec_helper'
Dir["./lib/**/*.rb"].each{ |f| require f }

describe FeedFetcher do

  it "should fetch and save feeds for given feed url" do
    blog = Feedzirra::Parser::Atom.new
    blog.entries = [Feedzirra::Parser::AtomEntry.new, Feedzirra::Parser::AtomEntry.new]
    blog.entries[0].title = "First Post"
    blog.entries[0].url = "test.url"
    blog.entries[0].author = "Dave Thomas"
    blog.entries[1].title = "Second Post"
    blog.entries[1].url = "test1.url"
    blog.entries[1].author = "Daven Thomas"

    Feedzirra::Feed.should_receive(:fetch_and_parse).with("feeds.dummy.com").and_return(blog)

    FeedFetcher.get_feed("feeds.dummy.com")
    Feed.count.should == 2
    Feed.all[0].title.should == "First Post"
    Feed.all[0].url.should == "test.url"
    Feed.all[0].author.should == "Dave Thomas"
    Feed.all[1].title.should == "Second Post"
    Feed.all[1].url.should == "test1.url"
    Feed.all[1].author.should == "Daven Thomas"
  end
end
