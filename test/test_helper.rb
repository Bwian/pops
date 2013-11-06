ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def setup_admin_session
    user = users(:brian)
    session[:user_id] = user.id
    session[:tip_entry_id] = user.id
    session[:admin] = user.admin
    session[:timeout] = Time.now.to_i + 300 
  end
end
