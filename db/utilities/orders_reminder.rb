#!/usr/bin/env ruby

require 'pry'
require "#{File.dirname(__FILE__)}/../../config/environment"

orders = Order.where(status: ['D','S','A'], created_at: Time.at(0)..1.month.ago)

order_list = []
orders.each do |order|
  line = "order #{order.id} created on #{order.created_at.strftime('%d/%m/%Y')} by #{order.creator.name} emailed to #{order.creator.email}."
  Rails.logger.info("Reminder for order #{line}")
  order_list << line
  mail = OrderMailer.reminder_email(order)
  mail.deliver
end

unless order_list.empty?
  users = User.where(admin: true)
  users.each do |user|
    mail = OrderMailer.reminder_summary(user,order_list)
    mail.deliver
  end
end



