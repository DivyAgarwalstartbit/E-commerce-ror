class CreateCollectionsProductsJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :collections_products_join_table do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
    end
  end
end
