class Product < ApplicationRecord
  has_many :collection_products, dependent: :destroy
  has_many :collections, through: :collection_products
  belongs_to :category , optional:true

  has_many :product_variant_options, dependent: :destroy
  has_many :product_variant_combinations, dependent: :destroy

  has_one_attached :featured_image

  after_create :assign_to_all_collection
  before_destroy :prevent_removal_from_all

  validates :name, presence: true, length: { maximum: 100 } 
  validates :short_description, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :brand, presence: true, length: { maximum: 100 }
  validates :specification, presence: true, length: { maximum: 2000 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :compare_price, numericality: { greater_than: 0 }, allow_nil: true 
  validate :compare_price_must_be_greater_than_price
  validates :featured_image, content_type: ['image/png', 'image/jpeg']
  validate :featured_image_size

  private

  def self.ransackable_attributes(auth_object = nil)
    %w[
      name
      price
      size
      color
      category_id
      created_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  def assign_to_all_collection
    all_collection = Collection.find_or_create_by(name: "All")
    collections << all_collection unless collections.include?(all_collection)
  end

  def prevent_removal_from_all
    if collections.exists?(name: "All")
      errors.add(:base, "Product cannot be removed from All collection")
      throw(:abort)
    end
  end

  def compare_price_must_be_greater_than_price
    return if compare_price.nil?
    if compare_price <= price
      errors.add(:compare_price, "must be greater than the price")
    end
  end

  def featured_image_size
    return unless featured_image.attached?
    if featured_image.blob.byte_size > 5.megabytes
      errors.add(:featured_image, "should be less than 5MB")
    end
  end
end
