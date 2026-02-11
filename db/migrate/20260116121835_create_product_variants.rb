class CreateProductVariants < ActiveRecord::Migration[6.1]
  def change
    create_table :product_variants do |t|
      t.string  :variant_type            
      t.string  :value

      t.references :product, foreign_key: true 
      t.timestamps
    end
  end
end
