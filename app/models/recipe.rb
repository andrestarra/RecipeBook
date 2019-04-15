class Recipe < ApplicationRecord
  validates :source, :location, presence: true, length: { in: 3..25 }
end
