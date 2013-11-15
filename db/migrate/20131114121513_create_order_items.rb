class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true
      t.references :program
      t.references :account
      t.string :description
      t.integer :quantity
      t.decimal :price
      t.references :tax_rate

      t.timestamps
    end
  end
end
