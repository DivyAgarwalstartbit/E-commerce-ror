class LineItem < ApplicationRecord
  belongs_to :cart, optional: true
  belongs_to :order, optional: true
  belongs_to :product_variant_combination

  delegate :product, to: :product_variant_combination

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_price
    quantity * price
  end
end
