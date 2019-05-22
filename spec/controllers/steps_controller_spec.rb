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
      @user.confirm
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
        @user.confirm
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

      context 'set flash messages in the rescue' do
        before { get :create }

        it { should set_flash }
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
        @user.confirm
      end

      it 'updates a step' do
        step_params = attributes_for(:step, :new_operation)
        patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: step_params }
        expect(@step.reload.operation).to eq 'NewOperation'
      end

      it 'can not update a step' do
        step_params = attributes_for(:step, :invalid)
        patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: step_params }
        expect(@step.reload.operation).to eq @step.operation
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: other_user.id, plate_id: @plate.id)
        @step = create(:step, recipe_id: @recipe.id)
        sign_in @user
        @user.confirm
      end

      it 'does not update the step' do
        step_params = attributes_for(:step, :new_operation)
        expect{ patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: step_params } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
        @step = create(:step, recipe_id: @recipe.id)
      end

      it 'returns a 302 response' do
        step_params = attributes_for(:step)
        patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: step_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        step_params = attributes_for(:step)
        patch :update, params: { recipe_id: @recipe.id, id: @step.id, step: step_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
        @step = create(:step, recipe_id: @recipe.id)
        sign_in @user
        @user.confirm
      end

      it 'deletes a step' do
        expect { delete :destroy, params: { recipe_id: @recipe.id, id: @step.id } }
          .to change(@recipe.steps, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: other_user.id, plate_id: @plate.id)
        @step = create(:step, recipe_id: @recipe.id)
        sign_in @user
        @user.confirm
      end

      it 'does not delete the step' do
        expect { delete :destroy, params: { recipe_id: @recipe.id, id: @step.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
        @step = create(:step, recipe_id: @recipe.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { recipe_id: @recipe.id, id: @step.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { recipe_id: @recipe.id, id: @step.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the step' do
        expect { delete :destroy, params: { recipe_id: @recipe.id, id: @step.id } }
          .to_not change(Step, :count)
      end
    end
  end
end
