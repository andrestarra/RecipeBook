require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:plates) }
  it { should have_many(:menus) }
  it { should have_many(:recipes) }
  it { should have_many(:ingredients) }
  it { should have_many(:utensils) }
end
