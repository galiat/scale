class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.integer :start_measurement_id
      t.integer :end_measurement_id
      t.timestamps
    end
  end
end
