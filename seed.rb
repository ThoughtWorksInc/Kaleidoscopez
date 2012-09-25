require './config/boot'

FeedSource.delete_all
Feed.delete_all
FeedSource.create({:name => "Hacker News", :url => "http://news.ycombinator.com/rss"})
FeedSource.create({:name => "Linus Torvald's Blog", :url => "http://torvalds-family.blogspot.com/feeds/posts/default"})
