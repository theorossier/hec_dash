# require 'mysql2'

# SCHEDULER.every '15m', :first_in => 0 do |job|

#   # Myql connection
#   db = Mysql2::Client.new(:host => "192.168.1.1", :username => "dashing", :password => "SECRET", :port => 3306, :database => "users" )

#   # Mysql query
#   sql = "SELECT acct AS account, COUNT( acct ) AS count FROM users ORDER BY COUNT(*) DESC LIMIT 0 , 5"

#   # Execute the query
#   results = db.query(sql)

#   # Sending to List widget, so map to :label and :value
#   acctitems = results.map do |row|
#     row = {
#       :label => row['account'],
#       :value => row['count']
#     }
#   end

#   # Update the List widget
#   send_event('account_count', { items: acctitems } )

# end