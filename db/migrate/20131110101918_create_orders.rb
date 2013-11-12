class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :supplier
      t.string :supplier_name
      t.string :invoice_no
      t.date :invoice_date
      t.date :payment_date
      t.string :reference
      t.references :creator
      t.datetime :created_at
      t.references :approver
      t.datetime :approved_at
      t.references :processor
      t.datetime :processed_at
      t.string :status

      t.timestamps
    end
  end
end
