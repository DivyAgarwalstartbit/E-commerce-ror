class CreateWishlistItems < ActiveRecord::Migration[6.1]
  def change
    create_table :wishlist_items do |t|
      t.references :wishlist, foreign_key: true 
      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
