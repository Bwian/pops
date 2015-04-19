class CreateTbrServices < ActiveRecord::Migration
  def change
    create_table :tbr_services do |t|
      t.references :manager, index: true
      t.references :user, index: true
      t.string :code
      t.string :name
      t.string :cost_centre
      t.string :rental
      t.string :service_type
      t.string :comment

      t.timestamps
    end
  end
end
