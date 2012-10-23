require './app/boot'

Source.delete_all
Item.delete_all

Feed.initialize("500px", "http://500px.com/popular.rss")
Feed.initialize("Quora", "http://quora.com/rss")
Feed.initialize("Quora: Technology: Best Questions", "http://www.quora.com/Technology/best_questions/rss")
Feed.initialize("Quora: India: Best Questions", "http://www.quora.com/India/best_questions/rss")
Feed.initialize("The Economist", "http://www.economist.com/topics/india/index.xml")
Feed.initialize("Google News", "http://news.google.com/news?ned=in&topic=n&output=rss")
Feed.initialize("XKCD", "http://xkcd.com/rss.xml")
Feed.initialize("CNET", "http://feeds.feedburner.com/cnet/NnTv")
Feed.initialize("Mashable", "http://feeds.mashable.com/Mashable")
Feed.initialize("Tech Crunch", "http://feeds.feedburner.com/TechCrunch/")
Feed.initialize("HBR", "http://feeds.harvardbusiness.org/harvardbusiness")
Feed.initialize("ThoughtWorks Events", "http://feeds.feedburner.com/thoughtworks-upcoming-events")
Feed.initialize("ThoughtWorks Blogs", "http://www.thoughtworks.com/blogs/rss/current")
TwitterSource.create(:name => "#ThoughtWorks", :query => "#thoughtworks")
MythoughtworksFeed.create(:name => "myTW: Pune Office", :group_name => "Pune Office")
