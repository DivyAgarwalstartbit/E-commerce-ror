class RemoveUnusedColumnsFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :model, :string
    remove_column :orders, :Order, :string
  end
end
