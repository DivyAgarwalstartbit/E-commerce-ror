class Category < ApplicationRecord
  belongs_to :collection, optional: true

  validates :name, presence: true, length: { maximum: 50 }
  validates :gender, presence: true, inclusion: { in: %w[Mens Womens Kids] }
end
