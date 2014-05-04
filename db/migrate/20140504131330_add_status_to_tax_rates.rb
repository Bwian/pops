class AddStatusToTaxRates < ActiveRecord::Migration
  def change
    add_column :tax_rates, :status, :string
  end
end
