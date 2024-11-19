class CreatePetsitters < ActiveRecord::Migration[7.1]
  def change
    create_table :petsitters do |t|
      t.integer :price
      t.string :bio
      t.references :user, null: false, foreign_key: true
      t.string :picture_url
      t.string :acceptable_pets

      t.timestamps
    end
  end
end
