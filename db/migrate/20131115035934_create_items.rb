class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :order, index: true
      t.references :program
      t.references :account
      t.references :tax_rate
      t.string :description
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
