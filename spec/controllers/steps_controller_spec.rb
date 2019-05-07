require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  describe '#create' do
    context 'as an autheticated user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
        sign_in @user
      end

      context 'with valid attributes' do
        it 'adds a step' do
          step_params = attributes_for(:step).merge(recipe_id: @recipe.id)
          expect { post :create, params: { recipe_id: @recipe.id, step: step_params } }
            .to change(@recipe.steps, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a step' do
          step_params = attributes_for(:step, :invalid)
          expect { post :create, params: { recipe_id: @recipe.id, step: step_params } }
            .to_not change(@recipe.steps, :count)
        end
      end
    end
  end

  describe '#update' do
  end

  describe '#destroy' do
  end
end
