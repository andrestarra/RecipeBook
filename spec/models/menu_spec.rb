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
end
