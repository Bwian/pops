class AddPhoneAndFiltersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :accounts_filter, :string
    add_column :users, :programs_filter, :string
  end
end
