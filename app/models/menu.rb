# frozen_string_literal: true

# Menu Model
class Menu < ApplicationRecord
  has_many :plates

  validates :name, :type_menu, presence: true, length: { in: 3..25 }
  validates :name, uniqueness: { scope: :type_menu }

  private

  def menu_and_type
    "#{name} - #{type_menu}"
  end
end
