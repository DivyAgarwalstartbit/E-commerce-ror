class ProductVariantCombinationitem < ApplicationRecord
    belongs_to :product_variant
    belongs_to :product_variant_combination
end
