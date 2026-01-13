class CreateRails < ActiveRecord::Migration[6.1]
  def change
    create_table :rails do |t|
     
      t.string :model
      t.string :Order
      t.references :user, null: false, foreign_key: true
      t.decimal :total_amount
      t.string :status
      t.references :billing_details, null: false, foreign_key: true

      t.timestamps
    end
  end
end
