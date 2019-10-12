# frozen_string_literal: true

# Step model
class Step < ApplicationRecord
  has_many :uses, dependent: :destroy
  has_many :utilities, dependent: :destroy
  belongs_to :recipe
  accepts_nested_attributes_for :uses,
                                :utilities,
                                reject_if: :all_blank,
                                allow_destroy: true,
                                limit: 3

  validates :operation, presence: true, length: { minimum: 3 }
  validates :expected_minutes, numericality: { greater_than: 0, less_than: 60 }
end
