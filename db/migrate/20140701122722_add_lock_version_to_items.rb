class AddLockVersionToItems < ActiveRecord::Migration
  def change
    add_column :items, :lock_version, :integer, default: 0
  end
end
