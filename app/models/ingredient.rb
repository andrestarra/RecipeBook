# frozen_string_literal: true

# Ingredient model
class Ingredient < ApplicationRecord
  has_many :uses, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { in: 3..20 }, uniqueness: { scope: :user_id }
  validates :calories, length: { maximum: 5 }

  scope :my_ingredients, -> { where(user_id: Plate.current_user.id) }
end
