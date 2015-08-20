class AddTbrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tbr_admin, :boolean, default: false
    add_column :users, :tbr_manager, :boolean, default: false
  end
end
