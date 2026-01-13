class ProductVariantCombination < ApplicationRecord
  belongs_to :product

  has_many :product_variant_combination_options, dependent: :destroy
  has_many :product_variant_options, through: :product_variant_combination_options
  has_many :wishlists

  validates :sku, presence: true, uniqueness: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Returns a human-readable combination name
  def display_name
    "#{product.name} - #{product_variant_options.map(&:value).join(', ')}"
  end
end
