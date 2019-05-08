require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  describe '#edit' do
    before do
      @user = create(:user)
      @menu = create(:menu, user_id: @user.id)
      @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
      @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
      @step = create(:step, recipe_id: @recipe.id)
      sign_in @user
    end

    it 'render edit template' do
      get :edit, params: { recipe_id: @recipe.id, id: @step.id }
      expect(response).to render_template(:edit)
    end

    it 'load recipe params in edit template' do
      get :edit, params: { recipe_id: @recipe.id, id: @step.id }
      expect(assigns(:step)).to eq(@step)
    end

    it 'no load with a nonexistent recipe' do
      expect { get :edit, params: { recipe_id: @recipe.id, id: 500 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

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
            .to change(Step, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a step' do
          step_params = attributes_for(:step, :invalid)
          expect { post :create, params: { recipe_id: @recipe.id, step: step_params } }
            .to_not change(Step, :count)
        end
      end
    end

    context 'as a guest' do
      it 'Not routes matches' do
        step_params = attributes_for(:step)
        expect{ post :create, params: { step: step_params } }
          .to raise_error(ActionController::UrlGenerationError)
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
        @step = create(:step, recipe_id: @recipe.id)
        sign_in @user
      end

      it 'updates a step' do
        step_params = attributes_for(:step, :new_operation)
        patch :update, params: { id: @recipe.id, step: step_params }
        expect(@step.reload.operation).to eq 'NewOperation'
      end

      it 'can not update a recipe' do
        recipe_params = attributes_for(:recipe, :invalid)
        patch :update, params: { id: @recipe.id, recipe: recipe_params }
        expect(@recipe.reload.source).to eq @recipe.source
      end
    end
  end

  describe '#destroy' do
  end
end
