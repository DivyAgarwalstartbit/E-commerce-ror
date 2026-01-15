
class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
     
      t.string :model
      t.string :Order
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status
     

      t.timestamps
    end
  end
end

