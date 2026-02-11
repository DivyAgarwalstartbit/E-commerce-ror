class Order < ApplicationRecord
    belongs_to :billing_detail
    belongs_to :user
    has_many :line_items
    has_one :payment
    has_many :product_variant_combinations, through: :line_items

    
    enum status: {
    placed: "placed",
    on_the_way: "on_the_way",
    delivered: "delivered",
    cancelled: "cancelled",
    pending: "pending"
  }
end
