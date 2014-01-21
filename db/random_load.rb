#!/usr/bin/env ruby

require "#{File.dirname(__FILE__)}/../config/environment"

DEFAULT_TAX_RATE = 32

ARGV[0] ||= 'D'
ARGV[1] ||= 1

status = ARGV[0]
order_count = ARGV[1].to_i

creators = User.where(:creator => true).ids
approvers = User.where(:approver => true).ids
processors = User.where(:processor => true).ids

suppliers = Supplier.where(nil).ids
accounts = Account.where(nil).ids
programs = Program.where(nil).ids
tax_rates = TaxRate.where(nil).ids
tax_rates.concat(Array.new(80,DEFAULT_TAX_RATE))  # make most default rate
item_details = [
  ['Cornflakes',3.45],
  ['Box of copy paper',15.65],
  ['Blue biros - box 20',2.34],
  ['Accomodation',234.50],
  ['Washing machine',450.00],
  ['Petrol',20.00],
  ['Coles vouchers - 10',500.00],
  ['Toaster',23.95],
  ['Printer ink',22.50],
  ['PostIts',1.15] 
]
acme_suppliers = [
  'Services',
  'Cleaners',
  'Paper and Print',
  'Canned Goods',
  'Stationery'
]

while order_count > 0
  order = Order.new
  order.supplier_id = suppliers[rand(suppliers.size)]
  order.supplier_name = "ACME #{acme_suppliers[rand(acme_suppliers.size)]}"
  order.invoice_no = rand(200000).to_s
  order.invoice_date = Time.now - rand(365).days
  order.payment_date = order.invoice_date + 30
  order.created_at = order.invoice_date
  order.reference = rand(200000).to_s
  order.creator_id = creators[rand(creators.size)]
  order.approver_id = approvers[rand(approvers.size)]
  
  case status
    when 'D','S'
      order.status = status
    when 'A'
      order.status = status
      order.approved_at = order.created_at + 2.days
    when 'P'      
      order.status = status
      order.approved_at = order.created_at + 2.days
      order.processed_at = order.approved_at + 2.days
      order.processor_id = processors[rand(processors.size)]
  end
  
  if order.save 
    item_count = rand(2) + 1
    while item_count > 0
      item = Item.new
      item.order_id = order.id
      item.program_id = programs[rand(programs.size)]
      item.account_id = accounts[rand(accounts.size)]
      item.tax_rate_id = tax_rates[rand(tax_rates.size)]
      item.quantity = 1
      details = item_details[rand(item_details.size)]
      item.description = details[0]
      item.price = details[1]
      item.save
      
      item_count -= 1
    end
    order_count -= 1
  end
end