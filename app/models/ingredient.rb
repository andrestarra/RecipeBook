# frozen_string_literal: true

# Ingredient model
class Ingredient < ApplicationRecord
  validates :name, presence: true, length: { in: 3..20 }
  validates :calories, length: { maximum: 5 }
end
