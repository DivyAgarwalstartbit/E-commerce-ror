class UpdateWishlistForCombination < ActiveRecord::Migration[6.1]
  def change
   
    # Remove old column
    remove_column :wishlists, :product_variant_id, :integer

    # Add correct column
    add_column :wishlists, :product_variant_combination_id, :integer, null: false

    # Add index
    add_index :wishlists, :product_variant_combination_id

    # Add foreign key
    add_foreign_key :wishlists, :product_variant_combinations, column: :product_variant_combination_id
  
  end
end
