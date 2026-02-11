class CreateProductVariantCombinationitems < ActiveRecord::Migration[6.1]
  def change
    create_table :product_variant_combinationitems do |t|
      t.references :product_variant, foreign_key: true
      t.references :product_variant_combination, foreign_key: true , index: { name: 'index_pvc_items_on_pvc_id'}

      t.timestamps
    end
  end
end
