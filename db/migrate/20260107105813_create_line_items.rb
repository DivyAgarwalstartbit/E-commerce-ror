class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
