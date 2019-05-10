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

  access_token = OmniAuth::AuthHash.new({
    provider: 'google',
    uid: '1234',
    info: {
      name: 'test',
      email: 'test@test.com'
    }
  })

  describe '#from_omniauth' do
    it 'retrieves an existing user' do
      user = User.new(
        provider: 'google',
        uid: '1234',
        name: 'test',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user.save
      omniauth_user = User.from_omniauth(access_token)

      expect(user).to eq(omniauth_user)
    end

    it "creates a new user if one doesn't already exist" do
      expect(User.count).to eq(0)

      omniauth_user = User.from_omniauth(access_token)
      expect(User.count).to eq(1)
    end
  end
end
