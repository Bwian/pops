class AddTbrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tbr_admin, :boolean
    add_column :users, :tbr_manager, :boolean
  end
end
