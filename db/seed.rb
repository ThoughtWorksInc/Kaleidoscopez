require './app/boot'

Source.delete_all
Item.delete_all

Feed.initialize("XKCD","http://xkcd.com/rss.xml")
Feed.initialize("Tech Crunch","http://feeds.feedburner.com/TechCrunch/")
Feed.initialize("ThoughtWorks Events","http://feeds.feedburner.com/thoughtworks-upcoming-events")
Feed.initialize("ThoughtWorks Blogs","http://www.thoughtworks.com/blogs/rss/current")
Feed.initialize("HBR","http://feeds.harvardbusiness.org/harvardbusiness")
