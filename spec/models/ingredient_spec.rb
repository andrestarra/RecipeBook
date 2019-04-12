require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3) }
  it { should validate_length_of(:name).is_at_most(20) }
  it { should validate_length_of(:calories).is_at_most(5) }
end
