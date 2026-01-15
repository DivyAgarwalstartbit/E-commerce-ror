class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
       
      t.string  :name, null: false
      t.string  :short_description
      t.text    :description
      t.string  :brand

     

      t.text    :specification

      t.references :collection, foreign_key: true
      t.references :category,   foreign_key: true

      t.timestamps
    end
  end
end
