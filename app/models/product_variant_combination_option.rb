class ProductVariantCombinationOption < ApplicationRecord
  belongs_to :product_variant_combination
  belongs_to :product_variant_option

  validates :product_variant_option_id, uniqueness: { scope: :product_variant_combination_id }

  delegate :variant_type, :value, to: :product_variant_option
end
