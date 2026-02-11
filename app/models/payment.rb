class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :order

  enum status: {
    pending: "pending",
    paid: "paid",
    failed: "failed"
  }
end
