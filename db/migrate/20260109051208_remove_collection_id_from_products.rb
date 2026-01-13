class RemoveCollectionIdFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :collection_id, :integer
  end
end
