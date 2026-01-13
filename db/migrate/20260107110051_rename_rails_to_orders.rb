class RenameRailsToOrders < ActiveRecord::Migration[6.1]
  def change
    rename_table :rails, :orders
  end
end
