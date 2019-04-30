require 'rails_helper'

RSpec.describe Utility, type: :model do
  it { should belong_to(:step) }
  it { should belong_to(:utensil) }
  it { should validate_uniqueness_of(:step_id).scoped_to(:utensil_id) }
end
