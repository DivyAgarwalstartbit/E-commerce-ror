class Category < ApplicationRecord
    has_many :products
    belongs_to :collection

    validates :name , presence:true 

    def self.ransackable_attributes(auth_object = nil)
    %w[id name collection_id created_at updated_at]
  end

  # Whitelist associations (optional)
  def self.ransackable_associations(auth_object = nil)
    %w[products collection]
  end
end
