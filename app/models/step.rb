# frozen_string_literal: true

# Step model
class Step < ApplicationRecord
  has_many :uses
  has_many :utilities
  belongs_to :recipe

  validates :operation, presence: true, length: { minimum: 3 }
  validates :expected_minutes, length: { maximum: 5 }
end
