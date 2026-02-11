class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :slug
      t.string  :brand
      t.string  :promotion
      t.string  :short_description
      t.text    :description
      t.text    :specification
      t.boolean :featured
      
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
