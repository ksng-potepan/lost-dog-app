require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'devise'
require File.expand_path("spec/support/controller_macros.rb")
require_relative 'support/controller_macros'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec/fixtures').to_s
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.extend ControllerMacros, type: :controller

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, js: true, type: :system) do
    driven_by :selenium_remote
    host! "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end

Capybara.server_host = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
Capybara.server_port = 3000
Capybara.javascript_driver = :selenium_chrome_headless

Capybara.register_driver :selenium_remote do |app|
  url = "http://chrome:4444/wd/hub"
  opts = { desired_capabilities: :chrome, browser: :remote, url: }
  Capybara::Selenium::Driver.new(app, opts)
end
