require 'rails_helper'

RSpec.describe Plate, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_ingredient) }
  it { should validate_presence_of(:type_plate) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).
    is_greater_than(0) }
  it { should validate_numericality_of(:price).
    is_less_than(500_000) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should have_many(:recipes) }
  it { should belong_to(:menu) }
  it { should belong_to(:user) }
end
