class AddStatusToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :status, :string
  end
end
