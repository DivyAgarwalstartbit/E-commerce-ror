class ProductVariantCombination < ApplicationRecord
    belongs_to :product
    has_many :line_items , dependent: :destroy
    has_many :product_variant_combinationitems
    has_many :product_variants, through: :product_variant_combinationitems
    has_many :carts, through: :line_items 
    has_many :orders, through: :line_items
    has_one_attached :image 

    validates :sku, presence:true , uniqueness:true
    validates :price, presence:true , numericality:{ greater_than_or_equal_to: 0 }
    validates :stock_qunatity, presence: true , numericality: { only_integer:true , greater_than_or_equal_to: 0}
    validates :compared_price, numericality:{ greater_than_or_equal_to: 0 }, allow_nil: true

    before_validation :generate_sku, on: :create

      # Allow these fields to be searchable by Ransack
   def self.ransackable_attributes(auth_object = nil)
    %w[price compared_price sku stock_qunatity]
  end
 def image_url
    return unless image.attached?
    Rails.application.routes.url_helpers.url_for(image)
  end
  def self.ransackable_associations(auth_object = nil)
    %w[product product_variants]
  end
    private

    def generate_sku
        self.sku ||= "sku=#{SecureRandom.hex(8)}"
    end
end
