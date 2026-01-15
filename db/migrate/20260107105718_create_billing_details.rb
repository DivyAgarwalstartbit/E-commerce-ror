class CreateBillingDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_details do |t|
      t.references :order, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :country
      t.string :street_address
      t.string :apartment_number
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end
end
