# frozen_string_literal: true

# User model
class User < ApplicationRecord
  has_many :plates, dependent: :destroy
  has_many :menus
  has_many :recipes
  has_many :ingredients
  has_many :utensils

  validates :name, :email, :password, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :trackable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data[:email]).first

    user ||= User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20])
  end
end
