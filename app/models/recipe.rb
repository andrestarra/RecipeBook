# frozen_string_literal: true

# Recipe Model
class Recipe < ApplicationRecord
  has_many :steps, dependent: :destroy
  belongs_to :plate

  validates :source, :location, presence: true, length: { in: 3..25 }
  validates :plate_id, presence: true
end
