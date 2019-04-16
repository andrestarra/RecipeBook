# frozen_string_literal: true

# Recipe Model
class Recipe < ApplicationRecord
  validates :source, :location, presence: true, length: { in: 3..25 }
end
