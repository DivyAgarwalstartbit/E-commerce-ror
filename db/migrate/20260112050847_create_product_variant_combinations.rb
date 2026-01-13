class CreateProductVariantCombinations < ActiveRecord::Migration[6.1]
  def change
     create_table :product_variant_combinations do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku, null: false
      t.integer :stock, default: 0, null: false
      t.decimal :price, precision: 10, scale: 2
      t.string :promotion

      t.timestamps
     end
  end
end
