require './app/boot'

Feed.delete_all
Item.delete_all
Feed.create({:name => "XKCD", :url => "http://xkcd.com/rss.xml"})
Feed.create({:name => "Linus Torvald's Blog", :url => "http://torvalds-family.blogspot.com/feeds/posts/default"})
Feed.create({:name => "Tech Crunch", :url => "http://feeds.feedburner.com/TechCrunch/"})
Feed.create({:name => "ThoughtWorks Events", :url => "http://feeds.feedburner.com/thoughtworks-upcoming-events"})
