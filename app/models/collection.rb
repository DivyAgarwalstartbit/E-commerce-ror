class Collection < ApplicationRecord
  has_many :collection_products, dependent: :destroy
  has_many :products, through: :collection_products
  has_many :categories, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  
end
