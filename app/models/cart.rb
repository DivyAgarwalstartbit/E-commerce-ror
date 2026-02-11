class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items, dependent: :destroy
  has_many :product_variant_combinations, through: :line_items
  
# app/models/cart.rb

  def merge!(guest_cart)
    return if guest_cart.blank?

    guest_cart.line_items.each do |guest_item|
      existing_item = line_items.find_by(
        product_variant_combination_id: guest_item.product_variant_combination_id
      )

      if existing_item
        existing_item.quantity += guest_item.quantity
        existing_item.save!
      else
        line_items.create!(
          product_variant_combination_id: guest_item.product_variant_combination_id,
          quantity: guest_item.quantity
        )
      end
    end

    guest_cart.destroy
  end


  def total_amount
    line_items.includes(:product_variant_combination).sum do |item|
      item.quantity * item.product_variant_combination.price
    end
  end

end
