require './app/boot'

Source.delete_all
Item.delete_all

five_hundred_px = Feed.initialize("500px", "http://500px.com/editors.rss?only=Animals", "http://learningdslr.com/wp-content/uploads/2011/11/500px-iPad-Logo.png","false")
quora = Feed.initialize("Quora", "http://quora.com/rss", "http://qph.cf.quoracdn.net/main-qimg-f61a4d3c922757b1f5f354f28f4c3558")
quora_technology = Feed.initialize("Quora: Technology: Best Questions", "http://www.quora.com/Technology/best_questions/rss", "http://qph.cf.quoracdn.net/main-qimg-f61a4d3c922757b1f5f354f28f4c3558")
quora_india = Feed.initialize("Quora: India: Best Questions", "http://www.quora.com/India/best_questions/rss", "http://qph.cf.quoracdn.net/main-qimg-f61a4d3c922757b1f5f354f28f4c3558")
google_news = Feed.initialize("Google News", "http://news.google.com/news?ned=in&topic=n&output=rss", "http://www.gstatic.com/news/img/logo/en_in/news.gif")
xkcd = Feed.initialize("XKCD", "http://xkcd.com/rss.xml", "http://imgs.xkcd.com/store/imgs/hoodie_square_0.png", "false")
cnet = Feed.initialize("CNET", "http://feeds.feedburner.com/cnet/NnTv", "http://www.thatvideogameblog.com/wp-content/uploads/2009/11/cnet-logo.png")
mashable = Feed.initialize("Mashable", "http://feeds.mashable.com/Mashable", "http://6.mshcdn.com/wp-content/uploads/2010/04/Mashable_Logo_230px.jpg")
tech_crunch = Feed.initialize("Tech Crunch", "http://feeds.feedburner.com/TechCrunch/", "http://tctechcrunch2011.files.wordpress.com/2011/11/techcrunch_transparent.png")
hbr = Feed.initialize("HBR", "http://feeds.harvardbusiness.org/harvardbusiness", "http://www.creativeclass.com/_wp/wp-content/uploads/manual/clients/HBR.gif")
tw_events = Feed.initialize("ThoughtWorks Events", "http://feeds.feedburner.com/thoughtworks-upcoming-events", "http://blog.platogo.com/wp-content/uploads/thoughtworks.gif")
tw_blogs = Feed.initialize("ThoughtWorks Blogs", "http://www.thoughtworks.com/blogs/rss/current", "http://blog.platogo.com/wp-content/uploads/thoughtworks.gif")
twitter_tw = TwitterSource.create(:name => "#ThoughtWorks", :query => "#thoughtworks", :image_url => "http://netrightdaily.com/wp-content/uploads/2012/04/Twitter.png")
my_tw_PuneDashboard = MyTWContent.create(:name => "myTW", :comment_tag => "PuneDashboard", :image_url => "https://my.thoughtworks.com/themes/generated_advanced_skin_global/images/myThoughtworks_logo.png")
my_tw_BangaloreDashboard = MyTWContent.create(:name => "myTW", :comment_tag => "BangaloreDashboard", :image_url => "https://my.thoughtworks.com/themes/generated_advanced_skin_global/images/myThoughtworks_logo.png")
flickr_TWPune = Flickr.create(:name => "Traditional Day", :tags => "TWPune", :image_url => "http://www.undp.org.tr/Images/SM_flickr.jpg")

common_sources = [five_hundred_px, quora, quora_technology, quora_india, google_news, xkcd, cnet, mashable, tech_crunch, hbr, tw_events, tw_blogs, twitter_tw]
pune_sources = common_sources + [my_tw_PuneDashboard,flickr_TWPune]
bangalore_sources = common_sources + [my_tw_BangaloreDashboard]

Channel.create(:name => "Pune", :sources => pune_sources)
Channel.create(:name => "Bangalore",:sources => bangalore_sources)
