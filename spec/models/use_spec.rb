require 'rails_helper'

RSpec.describe Use, type: :model do
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:measure) }
  it { should validate_length_of(:measure).is_at_most(10) }
  it { should belong_to(:step) }
  it { should belong_to(:ingredient) }
  it { should validate_uniqueness_of(:step_id).scoped_to(:ingredient_id) }
end
