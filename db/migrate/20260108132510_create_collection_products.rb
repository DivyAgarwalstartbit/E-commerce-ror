class CreateCollectionProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :collection_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
