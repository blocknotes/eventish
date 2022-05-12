# frozen_string_literal: true

require 'action_controller/railtie'
require 'active_job/railtie'
require 'active_record/railtie'

require 'eventish'

# Main application class
class TestApp < Rails::Application
  config.action_controller.default_protect_from_forgery = true
  config.active_record.legacy_connection_handling = false
  config.autoload_paths << Rails.root.join('lib')
  config.eager_load = true
  config.hosts << 'example.org'
  config.logger = Logger.new($stdout)
  config.root = __dir__
  config.session_store :cookie_store, key: 'cookie_store_key'
  secrets.secret_key_base = 'secret_key_base'
  Rails.logger = config.logger

  routes.append do
    get '/home' => ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['Home']] }
  end
end

# App setup
Rails.application.initialize!

[
  'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), track_expenses BOOL)',
  'CREATE TABLE IF NOT EXISTS balances(id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, date DATE, total_amount DECIMAL NOT NULL DEFAULT 0)'
].each do |sql|
  ActiveRecord::Base.connection.exec_query(sql)
end
