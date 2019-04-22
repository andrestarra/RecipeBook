# frozen_string_literal: true

# Use model
class Use < ApplicationRecord
  belongs_to :step
  belongs_to :ingredient

  validates :quantity, presence: true, numericality: { greater_than: 0,
                                                       less_than: 50_000 }
  validates :measure, presence: true, length: { maximum: 10 }
  validates :step, uniqueness: { scope: :ingredient }
end
