# frozen_string_literal: true

# Recipe Model
class Recipe < ApplicationRecord
  has_many :steps, dependent: :destroy
  belongs_to :plate
  belongs_to :user

  validates :source, :location, presence: true, length: { in: 3..25 }
  validates :total_minutes, numericality: { greater_than: 0, less_than: 120 }
  
  scope :my_recipes, -> { where(user_id: Plate.current_user.id) }
end
