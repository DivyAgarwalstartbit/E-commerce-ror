class Product < ApplicationRecord
    belongs_to :category , required: true
    has_many :product_variants
    has_many :product_variant_combinations 
    has_many :wishlist_items
    has_many :wishlists, through: :wishlist_items
    has_and_belongs_to_many :collections , join_table: "collections_products_join_table"
    has_one_attached :featured_image
    accepts_nested_attributes_for :product_variants, allow_destroy: true
    accepts_nested_attributes_for :product_variant_combinations, allow_destroy: true

    validates :name, presence: true 
    validates :brand, presence:true 
    validates :description , length: {maximum: 1000}
    validates :specification , length: {maximum: 2000}
    validates :short_description , length: {maximum: 500}
    validates :featured , inclusion: { in: [true, false]} 
    validates :slug , presence: true , uniqueness: true 
      
     def default_variant_combination
         product_variant_combinations.order(:id).first
     end

    def variant_groups
        product_variants.group_by(&:variant_type)
    end

     
    def to_param
        slug
    end

   def self.ransackable_associations(auth_object = nil)
  ["product_variant_combinations", "category", "collections"]
end

end
