# frozen_string_literal: true

# Menu Model
class Menu < ApplicationRecord
  validates :name, :type_menu, presence: true, length: { in: 3..25 }
end
