# frozen_string_literal: true

# This file provides snippets of code that could be useful for testing in dummy Rails app.
# Copy and paste them to controllers, models, etc if necessary.

#
# Example of making various HTTP requests to mock HTTP server.
#
Net::HTTP.start('mock-http-server', 80) do |http|
  http.get('/get')
  http.post('/post', { foo: 'bar' }.to_json)
  http.put('/put', { foo: 'bar' }.to_json)
  http.patch('/patch', { foo: 'bar' }.to_json)
  http.delete('/delete')
end

#
# Example of making various SQL queries.
# Since it does not matter whether tables or columns actually exist in the database for testing, errors are ignored.
#
10.times do |i|
  5.times do |j|
    execute_sql("SELECT * from table#{i} where column = '#{j}'")
    execute_sql("UPDATE table#{i} SET column = '#{j}'")
    execute_sql("DELETE FROM table#{i} WHERE column = '#{j}'")
    execute_sql("INSERT INTO table#{i} (column) VALUES ('#{j}')")
  end
end

def execute_sql(sql)
  ActiveRecord::Base.connection.execute(sql)
rescue ActiveRecord::StatementInvalid
  # Ignored
end
