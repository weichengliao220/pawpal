class AddRatingToPetsitters < ActiveRecord::Migration[7.1]
  def change
    add_column :petsitters, :rating, :decimal, precision: 2, scale: 1, default: 0.0
  end
end
