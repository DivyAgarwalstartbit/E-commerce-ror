class Collection < ApplicationRecord
    has_many :categories
    has_and_belongs_to_many :products,join_table: "collections_products_join_table"
    validates :name , presence:true
    validates :description , length: {maximum: 500}
end
