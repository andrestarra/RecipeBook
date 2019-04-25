# frozen_string_literal: true

# Menu Model
class Menu < ApplicationRecord
  has_many :plates
  belongs_to :user

  validates :name, :type_menu, presence: true, length: { in: 3..25 }
  validates :name, uniqueness: { scope: :type_menu }

  cattr_accessor :current_user

  scope :my_menus, -> { where(user_id: Plate.current_user.id) }

  private

  def menu_and_type
    "#{name} - #{type_menu}"
  end
end
