class BillingDetail < ApplicationRecord
    belongs_to :user , foreign_key: :users_id
    has_many :orders

    validates :first_name , presence: true
    validates :last_name , presence: true
    validates :street_address , presence: true 
    validates :city , presence: true
    validates :state , presence: true 
    validates :email , presence: true 
    validates :phone_number , presence:true 
    validates :country , presence: true 
    validates :postal_code , presence: true 
    
end
