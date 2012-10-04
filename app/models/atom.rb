require './app/models/feed'

class Atom < Feed

  def save_item(feed_entry)
    date = feed_entry.published.strftime("%Y-%m-%d")
    content = Nokogiri::HTML(feed_entry.content)
    img = content.css('img').map{ |i| i['src'] }
    self.items.create({:title => feed_entry.title, :url => feed_entry.url, :author => feed_entry.author, :date => date, :image => img[0]})
  end

end
