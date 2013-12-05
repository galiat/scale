class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :user_id
      t.float :weight
      t.timestamp :taken_at
      t.timestamps
    end
  end
end
