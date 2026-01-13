class AddForeignKeyToLineItems < ActiveRecord::Migration[6.1]
  def change
    
    add_foreign_key :line_items, :product_variant_combinations, column: :product_variant_combination_id
    add_foreign_key :line_items, :carts
    add_foreign_key :line_items, :orders
  
  end
end
