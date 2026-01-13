class ProductVariantOption < ApplicationRecord
  belongs_to :product

  has_many :product_variant_combination_options, dependent: :destroy
  has_many :product_variant_combinations, through: :product_variant_combination_options

  validates :variant_type, presence: true, length: { maximum: 50 }
  validates :value, presence: true, length: { maximum: 50 }
  validates :value, uniqueness: { scope: [:product_id, :variant_type], message: "Option already exists for this product and variant type" }
end
