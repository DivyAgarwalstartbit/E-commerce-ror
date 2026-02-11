class ProductVariant < ApplicationRecord
    belongs_to :product
    has_many :product_variant_combinationitems
    has_many :product_variant_combinations, through: :product_variant_combinationitems

    validates :variant_type, presence:true
    validates :value , presence:true
     def self.ransackable_attributes(auth_object = nil)
    ["variant_type", "value"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product", "product_variant_combinations"]
  end

end
