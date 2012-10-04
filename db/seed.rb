require './config/boot'

Feed.delete_all
Item.delete_all
Rss.create({:name => "XKCD", :url => "http://xkcd.com/rss.xml"})
Atom.create({:name => "Linus Torvald's Blog", :url => "http://torvalds-family.blogspot.com/feeds/posts/default"})
RssFeedBurner.create({:name => "Tech Crunch", :url => "http://feeds.feedburner.com/TechCrunch/"})
RssFeedBurner.create({:name => "ThoughtWorks Events", :url => "http://feeds.feedburner.com/thoughtworks-upcoming-events"})
