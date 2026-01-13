class CreateProductVariants < ActiveRecord::Migration[6.1]
  def change
    create_table :product_variants do |t|
     t.references :product, null: false, foreign_key: true   

      t.string  :variant_type, null: false              
      t.string  :value, null: false
      t.integer :in_stock, null: false, default: 0
      t.string  :promotions, null: false

      t.timestamps
    end
  end
end
