class Wishlist < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product_variant_combination

  # Optional convenience association
  has_one :product, through: :product_variant_combination

  # Ensure a registered user cannot add the same combination twice
  # Guests (user_id: nil) are allowed multiple entries
  validates :product_variant_combination_id, uniqueness: { scope: :user_id }, if: -> { user_id.present? }
end
