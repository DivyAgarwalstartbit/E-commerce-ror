class Wishlists < ActiveRecord::Migration[6.1]
  def change
    create_table :wishlists do |t|
      t.references :user, null: true, foreign_key: true  # allow null for guest users
      t.references :product_variant, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
