# frozen_string_literal: true
class DebugsController < ApplicationController
  # For testing purposes, this controller makes multiple API calls and SQL queries.
  def index
    Net::HTTP.start('mock-http-server', 80) do |http|
      http.get('/get')
      http.post('/post', { foo: 'bar' }.to_json)
      http.put('/put', { foo: 'bar' }.to_json)
      http.patch('/patch', { foo: 'bar' }.to_json)
      http.delete('/delete')
    end

    10.times do |i|
      5.times do |j|
        execute_sql("SELECT * from table#{i} where column = '#{j}'")
        execute_sql("UPDATE table#{i} SET column = '#{j}'")
        execute_sql("DELETE FROM table#{i} WHERE column = '#{j}'")
        execute_sql("INSERT INTO table#{i} (column) VALUES ('#{j}')")
      end
    end

    render html: '<h3>Endpoint for Debug</h3> <p>Multiple SQL queries and API calls are made.</p>'.html_safe,
           layout: 'application'
  end

  def execute_sql(sql)
    ActiveRecord::Base.connection.execute(sql)
  rescue ActiveRecord::StatementInvalid
    # Ignored
  end
end
