class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.string :short_name
      t.decimal :rate
    end
  end
end
