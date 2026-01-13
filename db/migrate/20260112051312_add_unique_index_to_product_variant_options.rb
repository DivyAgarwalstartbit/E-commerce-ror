class AddUniqueIndexToProductVariantOptions < ActiveRecord::Migration[6.1]
  def change
     add_index :product_variant_options,
              [:product_id, :variant_type, :value],
              unique: true,
              name: "index_unique_variant_options"
  end
end
