class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.integer :before_measurement_id
      t.integer :after_measurement_id
      t.timestamps
    end
  end
end
