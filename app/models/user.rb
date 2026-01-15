class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Roles
  enum role: { user: "user", admin: "admin" }

  after_initialize :set_default_role, if: :new_record?

  # Associations
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :wishlists, dependent: :destroy

  private

  def set_default_role
    self.role ||= "user"
  end
end
