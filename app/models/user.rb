class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :orders , dependent: :destroy
  has_one :cart, dependent: :destroy
  has_one :wishlist, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :billing_details , dependent: :destroy , foreign_key: :users_id

 def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
  end
end

end
