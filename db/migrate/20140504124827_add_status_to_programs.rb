class AddStatusToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :status, :string
    remove_column :programs, :code
  end
end
