class UpdateLineItems < ActiveRecord::Migration[6.1]
  def change
    change_column :line_items, :order_id, :integer, null: true
    change_column :line_items, :quantity, :integer, default: 1
    change_column :line_items, :price, :decimal, precision: 10, scale: 2
  end
end
