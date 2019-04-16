class Plate < ApplicationRecord
  validates :name, :main_ingredient, :type_plate, presence: true, length: { in: 3..25 }
  validates :price, presence:true, numericality: { greater_than: 0, less_than: 500000 }
end
