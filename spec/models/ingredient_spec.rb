require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name) }
  it { should validate_length_of(:calories).is_at_most(5) }
  it { should have_many(:uses) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
end
