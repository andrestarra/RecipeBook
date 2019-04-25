class User < ApplicationRecord
  has_many :plates, dependent: :destroy
  has_many :menus
  has_many :recipes
  has_many :ingredients
  has_many :utensils
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
