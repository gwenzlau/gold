class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signature, :string
  end
end
