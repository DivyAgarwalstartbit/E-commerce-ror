class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :stripe_payment_intent_id
      t.integer :amount
      t.string :currency
      t.string :status

      t.timestamps
    end
  end
end
