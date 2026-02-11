class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :status
      t.decimal :total_price
      t.references :billing_detail, foreign_key: true
      t.references :user, foreign_key: true


      t.timestamps
    end
  end
end
