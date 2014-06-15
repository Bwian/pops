class CreatePaymentTerms < ActiveRecord::Migration
  def change
    create_table :payment_terms do |t|
      t.string :name
      t.integer :factor
      t.string :status
    end
    
    add_column :suppliers, :payment_term_id, :integer
  end
end
