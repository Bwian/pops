class AddApprovalLimitToUser < ActiveRecord::Migration
  def change
    add_column :users, :approval_limit, :decimal
  end
end
