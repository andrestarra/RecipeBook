# frozen_string_literal: true

# Ingredient model
class Ingredient < ApplicationRecord
  has_many :uses, dependent: :destroy

  validates :name, presence: true, length: { in: 3..20 }
  validates :calories, length: { maximum: 5 }
end
