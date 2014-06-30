class AddLockVersionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :lock_version, :integer, default: 0
  end
end
