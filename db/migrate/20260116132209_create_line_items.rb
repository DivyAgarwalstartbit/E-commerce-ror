class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.decimal :price 
      t.references :product_variant_combination, foreign_key:true
      t.references :order, foreign_key:true
      t.references :cart, foreign_key:true

      t.timestamps
    end
  end
end
