class Cart < ApplicationRecord
  belongs_to :user, optional: true

  has_many :line_items, dependent: :destroy
  has_many :product_variant_combinations, through: :line_items

  # Add a variant combination to the cart
  def add_variant(combination)
    item = line_items.find_or_initialize_by(product_variant_combination: combination)
    item.quantity = (item.quantity || 0) + 1
    item.price = combination.price
    item.save!
  end

  # Calculate total cart amount
  def total_amount
    line_items.sum('quantity * price')
  end
end
