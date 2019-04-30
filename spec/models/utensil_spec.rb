require 'rails_helper'

RSpec.describe Utensil, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name) }
  it { should have_many(:utilities) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
end
