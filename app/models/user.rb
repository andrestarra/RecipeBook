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
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
