require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  describe '#index' do
    context "as an authenticated user" do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        sign_in @user
        @user.confirm
      end
      
      it 'responds successfully' do
        get :index
        aggregate_failures do
          expect(response).to be_successful
          expect(response).to have_http_status "200"
        end
      end

      it 'empty array when there is no data' do
        get :index
        expect(assigns(:recipes)).to be_empty
      end

      it 'assigns recipe arrays' do
        get :index
        @recipes = create_list(:recipe, 10, user_id: @user.id, plate_id: @plate.id)
        expect(assigns(:recipes).count).to eq 10
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
        sign_in @user
        @user.confirm
      end

      it 'responds successfully' do
        get :show, params: { id: @recipe.id }
        expect(response).to be_successful
      end

      it 'no show with a nonexistent recipe' do
        expect{ get :show, params: { id: 500 } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: other_user.id, plate_id: @plate.id)
        sign_in @user
        @user.confirm
      end

      it 'record not found to unauthorized user' do
        expect{ get :show, params: { id: @recipe.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#new' do
    before do
      @user = create(:user)
      sign_in @user
      @user.confirm
    end

    it 'render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new recipe' do
      get :new
      expect(assigns(:recipe)).to be_a_new(Recipe)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @menu = create(:menu, user_id: @user.id)
      @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
      @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
      sign_in @user
      @user.confirm
    end

    it 'render edit template' do
      get :edit, params: { id: @recipe.id }
      expect(response).to render_template(:edit)
    end

    it 'load recipe params in edit template' do
      get :edit, params: { id: @recipe.id }
      expect(assigns(:recipe)).to eq(@recipe)
    end

    it 'no load with a nonexistent recipe' do
      expect { get :edit, params: { id: 500 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'as an autheticated user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        sign_in @user
        @user.confirm
      end

      context 'with valid attributes' do
        it 'adds a recipe' do
          recipe_params = attributes_for(:recipe).merge(user_id: @user.id, plate_id: @plate.id)
          expect { post :create, params: { recipe: recipe_params } }
            .to change(@user.recipes, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a recipe' do
          recipe_params = attributes_for(:recipe, :invalid)
          expect { post :create, params: { recipe: recipe_params } }
            .to_not change(@user.recipes, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        recipe_params = attributes_for(:recipe)
        post :create, params: { recipe: recipe_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        recipe_params = attributes_for(:recipe)
        post :create, params: { recipe: recipe_params }
        expect(response).to redirect_to '/users/sign_in'
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
        sign_in @user
        @user.confirm
      end

      it 'updates a recipe' do
        recipe_params = attributes_for(:recipe, :new_source)
        patch :update, params: { id: @recipe.id, recipe: recipe_params }
        expect(@recipe.reload.source).to eq 'NewSource'
      end

      it 'can not update a recipe' do
        recipe_params = attributes_for(:recipe, :invalid)
        patch :update, params: { id: @recipe.id, recipe: recipe_params }
        expect(@recipe.reload.source).to eq @recipe.source
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: other_user.id, plate_id: @plate.id)
        sign_in @user
        @user.confirm
      end

      it 'does not update the recipe' do
        recipe_params = attributes_for(:recipe, :new_source)
        expect{ patch :update, params: { id: @recipe.id, recipe: recipe_params } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
      end

      it 'returns a 302 response' do
        recipe_params = attributes_for(:recipe)
        patch :update, params: { id: @recipe.id, recipe: recipe_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        recipe_params = attributes_for(:recipe)
        patch :update, params: { id: @recipe.id, recipe: recipe_params }
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
        sign_in @user
        @user.confirm
      end

      it 'deletes a recipe' do
        expect { delete :destroy, params: { id: @recipe.id } }
          .to change(@user.recipes, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: other_user.id, plate_id: @plate.id)
        sign_in @user
        @user.confirm
      end

      it 'does not delete the recipe' do
        expect { delete :destroy, params: { id: @recipe.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
        @recipe = create(:recipe, user_id: @user.id, plate_id: @plate.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @recipe.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @recipe.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the recipe' do
        expect { delete :destroy, params: { id: @recipe.id } }
          .to_not change(Recipe, :count)
      end
    end
  end
end
