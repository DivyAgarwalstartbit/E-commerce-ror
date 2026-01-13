class Rail < ApplicationRecord
  belongs_to :user
  belongs_to :billing_detail

  has_many :line_items, dependent: :nullify

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: ['pending', 'completed', 'cancelled', 'shipped']

  # Optional: helper to calculate total amount from line items
  def calculate_total!
    update(total_amount: line_items.sum { |li| li.quantity * li.price })
  end
end
