class AddApprovedAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :approved_amount, :decimal
  end
end
