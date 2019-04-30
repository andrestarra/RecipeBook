require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:location) }
  it { should validate_length_of(:source) }
  it { should validate_length_of(:location) }
  it { should have_many(:steps) }
  it { should belong_to(:plate) }
  it { should belong_to(:user) }
  it { should validate_numericality_of(:total_minutes).
    is_greater_than(0) }
  it { should validate_numericality_of(:total_minutes).
    is_less_than(120) }
end
