require 'rails_helper'

RSpec.describe Utility, type: :model do
  it { should belong_to(:step) }
  it { should belong_to(:utensil) }
end
