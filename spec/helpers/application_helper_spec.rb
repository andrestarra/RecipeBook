require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'flash class' do
    it 'notice flash' do
      expect(helper.flash_class('notice')).to eq('alert alert-info')
    end

    it 'success flash' do
      expect(helper.flash_class('success')).to eq('alert alert-success')
    end

    it 'error flash' do
      expect(helper.flash_class('error')).to eq('alert alert-danger')
    end

    it 'alert flash' do
      expect(helper.flash_class('alert')).to eq('alert alert-warning')
    end
  end

  describe 'resource name' do
    it 'get the user' do
      expect(helper.resource_name).to eq(:user)
    end
  end

  describe 'resource method' do
    before do
      @resource ||= User.new
    end

    it 'new User if not exits' do
      expect(helper.resource).to eq(@resource)
    end
  end

  describe 'devise mapping' do
    before do
      @devise_mapping ||= Devise.mappings[:user]
    end

    it 'map the user devise' do
      expect(helper.devise_mapping).to eq(@devise_mapping)
    end
  end

  describe 'resource class' do
    before do
      @resource_class = helper.devise_mapping.to
    end

    it 'return the resource class' do
      expect(helper.resource_class).to eq(@resource_class)
    end
  end
end
