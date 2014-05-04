class AddStatusToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :status, :string
  end
end
