# frozen_string_literal: true

# Utensil model
class Utensil < ApplicationRecord
  has_many :utilities, dependent: :destroy

  validates :name, presence: true, length: { in: 3..20 }
end
