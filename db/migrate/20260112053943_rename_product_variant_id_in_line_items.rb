class RenameProductVariantIdInLineItems < ActiveRecord::Migration[6.1]
  def change
     
    rename_column :line_items, :product_variant_id, :product_variant_combination_id
  
  end
end
