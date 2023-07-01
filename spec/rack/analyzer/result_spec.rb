# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Rack::Analyzer::Result do
  let(:target) { described_class.new(id) }
  let(:id) { SecureRandom.uuid }

  it 'works' do
    target.add_request(status: 200, method: 'GET', path: '/users', endpoint: 'UserController#index', duration: 100)
    target.add_sql(name: 'User Load', statement: "SELECT * FROM users WHERE name like '%hoge' and birthday < '2000-01-01'", stack_trace: ['app/controllers/user_controller.rb:1:in `index`'], duration: 10, cached: false)
    target.add_sql(name: 'User Load', statement: "SELECT * FROM users WHERE name like '%hoge' and birthday < '2000-01-01'", stack_trace: ['app/controllers/user_controller.rb:1:in `index`'], duration: 10, cached: true)
    expect(target.to_h).to(
      eq({
           :id => id,
           :request => {
             :status => 200,
             :method => "GET",
             :path => "/users",
             :endpoint => "UserController#index",
             :duration => 100
           },
           :sql => {
             :crud => {
               "R_users" => {
                 :type => "R",
                 :table => "users",
                 :count => 2,
                 :duration => 20,
                 :query_ids => [1, 2]
               }
             },
             :normalized => {
               "SELECT * FROM users WHERE name LIKE ? AND birthday < ?" => {
                 :statement => "SELECT * FROM users WHERE name LIKE ? AND birthday < ?",
                 :count => 2,
                 :duration => 20,
                 :cached => 1,
                 :query_ids => [1, 2]
               }
             },
             :queries => [
               {
                 :id => 1,
                 :name => "User Load",
                 :statement => "SELECT * FROM users WHERE name like '%hoge' and birthday < '2000-01-01'",
                 :stack_trace => ["app/controllers/user_controller.rb:1:in `index`"],
                 :duration => 10,
                 :cached => false
               },
               {
                 :id => 2,
                 :name => "User Load",
                 :statement => "SELECT * FROM users WHERE name like '%hoge' and birthday < '2000-01-01'",
                 :stack_trace => ["app/controllers/user_controller.rb:1:in `index`"],
                 :duration => 10,
                 :cached => true
               }
             ]
           }
         })
    )
  end
end
