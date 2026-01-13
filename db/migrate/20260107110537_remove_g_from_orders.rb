class RemoveGFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :g, :string
  end
end
