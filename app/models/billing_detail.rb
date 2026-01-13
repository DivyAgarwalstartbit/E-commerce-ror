class BillingDetail < ApplicationRecord
  belongs_to :order

  # Validations
  validates :first_name, :last_name, :email, :street_address, :city, :country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
