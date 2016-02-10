

# # encoding: UTF-8

# require 'google/api_client'
# require 'date'
# require 'time'
# require 'digest/md5'
# require 'active_support'
# require 'active_support/all'
# require 'json'

# # Update these to match your own apps credentials
# service_account_email = '645475224899-q5fh431qi390303a606dr2jffmqdhg2b.apps.googleusercontent.com' # Email of service account
# key_file = 'Hec_Dash-157128b383e9.p12' # File containing your private key
# key_secret = 'notasecret' # Password to unlock private key
# calendarID = 'hec.fr_lcflmj0nhd48iutsgligabmui8@group.calendar.google.com' # Calendar ID.

# # Get the Google API client
# client = Google::APIClient.new(:application_name => 'Dashing Calendar Widget',
#   :application_version => '0.0.1')

# # Load your credentials for the service account
# if not key_file.nil? and File.exists? key_file
#   key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
# else
#   key = OpenSSL::PKey::RSA.new ENV['GOOGLE_SERVICE_PK'], key_secret
# end

# client.authorization = Signet::OAuth2::Client.new(
#   :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
#   :audience => 'https://accounts.google.com/o/oauth2/token',
#   :scope => 'https://www.googleapis.com/auth/calendar.readonly',
#   :issuer => service_account_email,
#   :signing_key => key)

# # Start the scheduler
# SCHEDULER.every '15m', :first_in => 4 do |job|

#   # Request a token for our service account
#   client.authorization.fetch_access_token!

#   # Get the calendar API
#   service = client.discovered_api('calendar','v3')

#   # Start and end dates
#   now = DateTime.now

#   result = client.execute(:api_method => service.events.list,
#                           :parameters => {'calendarId' => calendarID,
#                                           'timeMin' => now.rfc3339,
#                                           'orderBy' => 'startTime',
#                                           'singleEvents' => 'true',
#                                           'maxResults' => 6})  # How many calendar items to get

#   send_event('google_calendar', { events: result.data })

# end



require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'
require 'fileutils'

APPLICATION_NAME = 'dashing.io.google.calendar'
CLIENT_SECRETS_PATH = 'jobs/client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "google-calendar-dashing-job.json")
SCOPE = 'https://www.googleapis.com/auth/calendar.readonly'

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization request via InstalledAppFlow.
# If authorization is required, the user's default browser will be launched
# to approve the request.
#
# @return [Signet::OAuth2::Client] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
  storage = Google::APIClient::Storage.new(file_store)
  auth = storage.authorize

  if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
    app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
    flow = Google::APIClient::InstalledAppFlow.new({
      :client_id => app_info.client_id,
      :client_secret => app_info.client_secret,
      :scope => SCOPE})
    auth = flow.authorize(storage)
    puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
  end
  auth
end

# Initialize the API
client = Google::APIClient.new(:application_name => APPLICATION_NAME)
client.authorization = authorize
calendar_api = client.discovered_api('calendar', 'v3')

# Start the scheduler
SCHEDULER.every '15m', :first_in => 4 do |job|

  results = client.execute!(
    :api_method => calendar_api.events.list,
    :parameters => {
      :calendarId => 'primary',
      :maxResults => 3,
      :singleEvents => true,
      :orderBy => 'startTime',
      :timeMin => Time.now.iso8601 })

  send_event('google_calendar', { events: results.data })

end