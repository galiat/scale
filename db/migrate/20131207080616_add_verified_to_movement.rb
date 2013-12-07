class AddVerifiedToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :verified, :boolean, default: false
  end
end
