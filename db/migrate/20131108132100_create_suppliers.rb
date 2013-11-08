class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :phone
      t.string :fax
      t.string :email
      t.integer :tax_rate_id
    end
  end
end
