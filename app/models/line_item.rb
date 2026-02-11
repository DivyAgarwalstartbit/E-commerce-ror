class LineItem < ApplicationRecord
    belongs_to :product_variant_combination
    belongs_to :order , optional:true
    belongs_to :cart , optional:true 

    validates :quantity , presence: true , numericality: { only_integer: true , greater_than:0}
    
end
