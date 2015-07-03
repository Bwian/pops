class AddUniqueIndexToTbrServices < ActiveRecord::Migration
  def change
    add_index :tbr_services, [:code, :manager_id], unique: true 
  end
end
