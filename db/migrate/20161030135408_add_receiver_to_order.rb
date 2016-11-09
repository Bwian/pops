class AddReceiverToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :receiver, index: true
    add_column :orders, :received_at, :datetime
  end
end
