# frozen_string_literal: true

# Utensil model
class Utensil < ApplicationRecord
  has_many :utilities
  belongs_to :user

  validates :name, presence: true, length: { in: 3..20 }

  cattr_accessor :current_user

  scope :my_utensils, -> { where(user_id: Plate.current_user.id) }
end
