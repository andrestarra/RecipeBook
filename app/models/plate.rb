# frozen_string_literal: true

# Plate model
class Plate < ApplicationRecord
  has_many :recipes, dependent: :destroy
  belongs_to :menu
  belongs_to :user

  validates :name, uniqueness: true
  validates :name, :main_ingredient, :type_plate, presence: true, length: { in: 3..25 }
  validates :price, presence: true, numericality: { greater_than: 0, less_than: 500_000 }

  cattr_accessor :current_user

  scope :my_dishes, -> { where(user_id: current_user.id) }
end
