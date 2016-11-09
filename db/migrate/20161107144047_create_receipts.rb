class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :item, index: true
      t.string :status, default: 'A'
      t.decimal :price
      t.references :receiver, index: true
      t.timestamps
    end
  end
end
