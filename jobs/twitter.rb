

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
      { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https.scheme + "://" + tweet.user.profile_image_url_https.host + tweet.user.profile_image_url_https.path }
    end
    send_event('twitter_mentions', comments: tweets)
  rescue
  end
end