#!/usr/bin/env ruby

require 'pry'
require "#{File.dirname(__FILE__)}/../../config/environment"

orders = Order.where(status: ['D','S','A'], updated_at: Time.at(0)..30.days.ago)

order_list = {}
orders.each do |order|
  group = order_list[order.creator_id] || {}
  group[order.status] = group[order.status] || []
  group[order.status] << order
  order_list[order.creator_id] = group
end

summary_list = []
order_list.each do |key,list|
  user = User.find(key)
  mail = OrderMailer.reminder_email(user,list)
  mail.deliver

  ol = []
  list.each_value { |l| ol.concat(l) }
  summary_list << "#{user.name} (email: #{user.email || 'no address'}):"
  ol.each do |order|
    line = "- order #{order.id} (#{order.status_name}) created on #{order.created_at.strftime('%d/%m/%Y')}"
    summary_list << line
    Rails.logger.info("Reminder #{line}")
  end 
  summary_list << ' '
end

unless summary_list.empty?
  users = User.where(admin: true)
  users.each do |user|
    mail = OrderMailer.reminder_summary(user,summary_list)
    mail.deliver
  end
end



