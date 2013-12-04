class AddSecretAndKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secret, :string
    add_column :users, :key, :string
  end
end
