# require 'twitter'


# #### Get your twitter keys & secrets:
# #### https://dev.twitter.com/docs/auth/tokens-devtwittercom
# twitter = Twitter::REST::Client.new do |config|
#   config.consumer_key = 'cKFGNniHsqiWl1P9qXgxKw1Eh'
#   config.consumer_secret = 'flaP9MYLYNMaxJtfni8IvZ4GKHp2qY1qFXjFWCyxmRcJRSodtT'
#   config.access_token = '1849137277-ncS0wMwnyKEisVDsQ3jmB4Kek94YKakgLLNGnsx'
#   config.access_token_secret = 'heH5mQWyAVmeaPAEFWSILfMwM92Qcz0LSjafP6stxu0G0'
# end

# SCHEDULER.every '1m', :first_in => 0 do |job|
#   begin
#     user = twitter.user
#     if mentions
#       mentions = mentions.map do |tweet|
#         { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
#       end

#     send_event('twitter_mentions', {comments: mentions})
#     end    
#   rescue Twitter::Error
#     puts "\e[33mThere was an error with Twitter\e[0m"
#   end

# end

require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = 'cKFGNniHsqiWl1P9qXgxKw1Eh'
  config.consumer_secret = 'flaP9MYLYNMaxJtfni8IvZ4GKHp2qY1qFXjFWCyxmRcJRSodtT'
  config.access_token = '1849137277-ncS0wMwnyKEisVDsQ3jmB4Kek94YKakgLLNGnsx'
  config.access_token_secret = 'heH5mQWyAVmeaPAEFWSILfMwM92Qcz0LSjafP6stxu0G0'
end

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = client.search("HECParisExecEd", :result_type => "recent").each.map do |tweet|
      { name: tweet.text, body: tweet.user.screen_name, avatar: tweet.user.profile_image_url_https }
    end
    send_event('twitter_mentions', comments: tweets)
  rescue
  end
end