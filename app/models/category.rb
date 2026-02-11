class Category < ApplicationRecord
    has_many :products
    belongs_to :collection

    validates :name , presence:true 
end
