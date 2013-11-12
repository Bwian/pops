class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :supplier_id
      t.string :supplier_name
      t.string :invoice_no
      t.date :invoice_date
      t.date :payment_date
      t.string :reference
      t.integer :creator
      t.datetime :created_at
      t.integer :approver
      t.datetime :approved_at
      t.integer :processor
      t.datetime :processed_at
      t.string :status

      t.timestamps
    end
  end
end
