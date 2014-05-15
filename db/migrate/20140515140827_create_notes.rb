class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :order, index: true
      t.references :user
      t.text :info

      t.timestamps
    end
  end
end
