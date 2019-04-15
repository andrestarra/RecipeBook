# frozen_string_literal: true

# Step model
class Step < ApplicationRecord
  validates :operation, presence: true, length: { minimum: 3 }
  validates :expected_minutes, lenght: { maximum: 5 }
end
