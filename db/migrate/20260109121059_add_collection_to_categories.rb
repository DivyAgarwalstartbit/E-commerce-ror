class AddCollectionToCategories < ActiveRecord::Migration[6.1]
  def change
    add_reference :categories, :collection, foreign_key: true
  end
end
