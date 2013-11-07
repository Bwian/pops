class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :code
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :email
      t.integer :approver_id
      
      t.boolean :creator, default: true
      t.boolean :approver, default: false
      t.boolean :processor, default: false
      t.boolean :admin, default: false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
