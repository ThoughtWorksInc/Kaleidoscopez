require './app/boot'

Source.delete_all
Item.delete_all
Feed.create({:name => "XKCD", :url => "http://xkcd.com/rss.xml"})
Feed.create({:name => "Tech Crunch", :url => "http://feeds.feedburner.com/TechCrunch/"})
Feed.create({:name => "ThoughtWorks Events", :url => "http://feeds.feedburner.com/thoughtworks-upcoming-events"})
Feed.create({:name => "ThoughtWorks Blogs", :url => "http://www.thoughtworks.com/blogs/rss/current"})
Feed.create({:name => "HBR", :url => "http://feeds.harvardbusiness.org/harvardbusiness"})
TwitterSource.create({:name=>"#ThoughtWorks" ,:query=> "#thoughtworks"})
