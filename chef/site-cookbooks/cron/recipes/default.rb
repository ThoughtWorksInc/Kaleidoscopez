cron "fetch new items" do
    minute "*/10"
    command "bash --login -c 'cd /opt/Kaleidoscopez/current/; export TWITTER_CUSTOMER_KEY=#{ENV['TWITTER_CUSTOMER_KEY']}; export TWITTER_CUSTOMER_SECRET=#{ENV['TWITTER_CUSTOMER_SECRET']}; export TWITTER_OAUTH_TOKEN=#{ENV['TWITTER_OAUTH_TOKEN']}; export TWITTER_OAUTH_TOKEN_SECRET=#{ENV['TWITTER_OAUTH_TOKEN_SECRET']}; ruby app/jobs/clock.rb'"
end
