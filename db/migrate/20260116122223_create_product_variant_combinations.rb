class CreateProductVariantCombinations < ActiveRecord::Migration[6.1]
  def change
    create_table :product_variant_combinations do |t|
      t.integer :stock_qunatity
      t.decimal :price 
      t.decimal :compared_price
      t.string  :sku

      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
