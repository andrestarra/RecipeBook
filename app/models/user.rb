# frozen_string_literal: true

# User model
class User < ApplicationRecord
  has_many :plates, dependent: :destroy
  has_many :menus
  has_many :recipes
  has_many :ingredients
  has_many :utensils

  validates :name, :password, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :trackable
  devise :database_authenticatable, :registerable, :recoverable, :confirmable,
         :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data[:email]).first
    user ||= User.new(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20])
    user.skip_confirmation!
    user.save               
    user
  end
end
