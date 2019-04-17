# frozen_string_literal: true

# Step model
class Step < ApplicationRecord
  has_many :uses, dependent: :destroy
  has_many :utilities, dependent: :destroy
  belongs_to :recipe

  validates :operation, presence: true, length: { minimum: 3 }
  validates :expected_minutes, length: { maximum: 5 }
  validates :recipe_id, presence: true
end
