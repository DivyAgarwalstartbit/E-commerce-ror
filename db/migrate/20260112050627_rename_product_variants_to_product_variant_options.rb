class RenameProductVariantsToProductVariantOptions < ActiveRecord::Migration[6.1]
  def change
    rename_table :product_variants, :product_variant_options
  end
end
