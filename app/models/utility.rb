# frozen_string_literal: true

# Utility Model
class Utility < ApplicationRecord
  belongs_to :step
  belongs_to :utensil

  validates :step_id, :utensil_id, presence: true
  validates :step, uniqueness: { scope: :utensil }
end
