class CreateBillingDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :billing_details do |t|
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :apartment_name
      t.string :email
      t.string :phone_number 
      t.string :country 
      t.string :postal_code
      t.references :users, foreign_key:true
      t.timestamps
    end
  end
end
