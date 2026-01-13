class FixIndexesOnProductVariantCombinationOptions < ActiveRecord::Migration[6.1]
  
   def change
    add_index :product_variant_combination_options,
              :product_variant_combination_id,
              name: "idx_pvco_combination",
              if_not_exists: true

    add_index :product_variant_combination_options,
              :product_variant_option_id,
              name: "idx_pvco_option",
              if_not_exists: true
  end
 
 
end
