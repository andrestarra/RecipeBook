require 'rails_helper'

RSpec.describe Utility, type: :model do
  it { should belong_to(:step) }
  it { should belong_to(:utensil) }
  xit { should validate_uniqueness_of(:utensil_id).scoped_to(:step_id) }
end
