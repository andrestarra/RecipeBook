require 'rails_helper'

RSpec.describe Step, type: :model do
  it { should validate_presence_of(:operation) }
  it { should validate_length_of(:operation).is_at_least(3) }
  it { should have_many(:uses) }
  it { should have_many(:utilities) }
  it { should belong_to(:recipe) }
  it { should accept_nested_attributes_for(:uses) }
  it { should accept_nested_attributes_for(:utilities) }
  it { should validate_numericality_of(:expected_minutes).
    is_greater_than(0) }
  it { should validate_numericality_of(:expected_minutes).
    is_less_than(60) }
end
