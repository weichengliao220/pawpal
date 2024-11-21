class AddAddressToPetsitters < ActiveRecord::Migration[7.1]
  def change
    add_column :petsitters, :address, :string
  end
end
