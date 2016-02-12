# require 'google/api_client'
# require 'date'

# # Update these to match your own apps credentials
# service_account_email = 'ga-widget@hec-dash-1217.iam.gserviceaccount.com' # Email of service account
# key_file = 'hec-dash-8c9cd9e78671.p12' # File containing your private key
# key_secret = 'notasecret' # Password to unlock private key
# # Array of profile names and corresponding Analytics profile id
# profiles = [{name: 'HEC Executive Education', id: '48590729'},
#         # {name: 'site2', id: '22222222'},
#         # {name: 'site3', id: '33333333'},
#         # {name: 'site4', id: '44444444'}
#       ]

# # Get the Google API client
# client = Google::APIClient.new(:application_name => 'hec-dash', 
#   :application_version => '0.01')

# # Load your credentials for the service account
# key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
# client.authorization = Signet::OAuth2::Client.new(
#   :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
#   :audience => 'https://accounts.google.com/o/oauth2/token',
#   :scope => 'https://www.googleapis.com/auth/analytics.readonly',
#   :issuer => service_account_email,
#   :signing_key => key)

# # Start the scheduler
# SCHEDULER.every '1m', :first_in => 0 do # modified from 1m

#   # Request a token for our service account
#   client.authorization.fetch_access_token!

#   # Get the analytics API
#   analytics = client.discovered_api('analytics','v3')

#   # Start and end dates
#   startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
#   endDate = DateTime.now.strftime("%Y-%m-%d")  # now
  
#   visitors = Array.new

#   profiles.each do |profile|
#     # Execute the query
#     visitCount = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
#       'ids' => "ga:" + profile[:id],
#       'start-date' => startDate,
#       'end-date' => endDate,
#       # 'dimensions' => "ga:month",
#       'metrics' => "ga:visitors",
#       # 'sort' => "ga:month" 
#     })
    
#     if visitCount.data.rows[0] and visitCount.data.rows[0][0] # deals with no visits
#       visits = visitCount.data.rows[0][0]
#     else
#       visits = 0
#     end
    
#     visitors.push({label: profile[:name], value: visits})
# end

#   # Update the dashboard
#   send_event('visitor_count', {items: visitors})
# end