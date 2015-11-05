#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/../../config/environment"

user = User.new
user.code = 'test'
user.name = 'Test Name'
user.email = 'brian.pyrrho@bigpond.com'

summary_list = ['Line 1','Line 2']
mail = OrderMailer.reminder_summary(user,summary_list)
mail.deliver

Rails.logger.info("Reminder mail test")