require "rspec"

describe TwitterSource do

  before(:each) do
    @search_result = {
      :statuses => [{
        :created_at => Time.parse("Fri Oct 05 17:15:12 +0000 2012"),
        :text => "Tweet text",
        :media => [{
          :media_url => "media_url?params"
        }],
        :user => {
          :name => "user name",
          :profile_image_url =>"img_url"
        }
      },
      {
        :created_at => Time.parse("Fri Oct 06 17:15:12 +0000 2012"),
        :text => "Tweet text 2",
        :media => [],
        :user => {
          :name => "user name2",
          :profile_image_url =>"img_url2"
        }
      }] 
    }
  end

  it "should inherit source" do
    TwitterSource.ancestors.include?(Source).should be true
  end

  it "fetch items" do
    Twitter.should_receive(:search).with("xyz").and_return(@search_result)

    twitter_source = TwitterSource.new({:query => 'xyz'})
    items = twitter_source.fetch_items

    items[0].title.should == @search_result[:statuses][0][:text]
    items[0].date.should == "2012-10-05"
    items[0].author.should == @search_result[:statuses][0][:user][:name]
    items[0].image.should == "media_url"
    items[0].source.should == twitter_source
    items[0].author_image.should == @search_result[:statuses][0][:user][:profile_image_url]

    items[1].title.should == @search_result[:statuses][1][:text]
    items[1].date.should == "2012-10-06"
    items[1].author.should == @search_result[:statuses][1][:user][:name]
    items[1].image.should == nil
    items[1].source.should == twitter_source
    items[1].author_image.should == @search_result[:statuses][1][:user][:profile_image_url]

  end
end
