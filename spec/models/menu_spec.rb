require 'rails_helper'

RSpec.describe Menu, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type_menu) }
  it { should validate_length_of(:name) }
  it { should validate_length_of(:type_menu) }
  it { should validate_uniqueness_of(:name).
    scoped_to(%i[type_menu user_id]) }
  it { should have_many(:plates) }
  it { should belong_to(:user) }

  describe 'menu and type method' do
    before do
      @menu = build(:menu)
    end

    it 'return a string with the menu name and its type' do
      valid_result = "#{@menu.name} - #{@menu.type_menu}"
      expect(@menu.send(:menu_and_type)).to eq(valid_result)
    end
  end
end
