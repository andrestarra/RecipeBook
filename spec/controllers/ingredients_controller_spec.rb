require 'rails_helper'

RSpec.describe IngredientsController, type: :controller do
  describe '#index' do
    context "as an authenticated user" do
      before do
        @user = create(:user)
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
        expect(assigns(:ingredients)).to be_empty
      end

      it 'assigns ingredients arrays' do
        get :index
        @ingredients = create_list(:ingredient, 10, user_id: @user.id)
        expect(assigns(:ingredients).count).to eq 10
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
        @ingredient = create(:ingredient, user_id: @user.id)
        sign_in @user
        @user.confirm
      end

      it 'responds successfully' do
        get :show, params: { id: @ingredient.id }
        expect(response).to be_successful
      end

      it 'no show with a nonexistent ingredient' do
        expect{ get :show, params: { id: 500 } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @ingredient = create(:ingredient, user_id: other_user.id)
        sign_in @user
        @user.confirm
      end

      it 'record not found to unauthorized user' do
        expect{ get :show, params: { id: @ingredient.id } }
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

    it 'assigns a new ingredient' do
      get :new
      expect(assigns(:ingredient)).to be_a_new(Ingredient)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @ingredient = create(:ingredient, user_id: @user.id)
      sign_in @user
      @user.confirm
    end

    it 'render edit template' do
      get :edit, params: { id: @ingredient.id }
      expect(response).to render_template(:edit)
    end

    it 'load ingredient params in edit template' do
      get :edit, params: { id: @ingredient.id }
      expect(assigns(:ingredient)).to eq(@ingredient)
    end

    it 'no load with a nonexistent ingredient' do
      expect { get :edit, params: { id: 500 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'as an autheticated user' do
      before do
        @user = create(:user)
        sign_in @user
        @user.confirm
      end

      context 'with valid attributes' do
        it 'adds a ingredient' do
          ingredient_params = attributes_for(:ingredient).merge(user_id: @user.id)
          expect { post :create, params: { ingredient: ingredient_params } }
            .to change(@user.ingredients, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add an ingredient' do
          ingredient_params = attributes_for(:ingredient, :invalid)
          expect { post :create, params: { ingredient: ingredient_params } }
            .to_not change(@user.ingredients, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        ingredient_params = attributes_for(:ingredient)
        post :create, params: { ingredient: ingredient_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        ingredient_params = attributes_for(:ingredient)
        post :create, params: { ingredient: ingredient_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @ingredient = create(:ingredient, user_id: @user.id)
        sign_in @user
        @user.confirm
      end

      it 'updates an ingredient' do
        ingredient_params = attributes_for(:ingredient, :new_name)
        patch :update, params: { id: @ingredient.id, ingredient: ingredient_params }
        expect(@ingredient.reload.name).to eq 'New ingredient'
      end

      it 'can not update an ingredient' do
        ingredient_params = attributes_for(:ingredient, :invalid)
        patch :update, params: { id: @ingredient.id, ingredient: ingredient_params }
        expect(@ingredient.reload.name).to eq @ingredient.name
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @ingredient = create(:ingredient, user_id: other_user.id)
        sign_in @user
        @user.confirm
      end

      it 'does not update the ingredient' do
        ingredient_params = attributes_for(:ingredient, :new_name)
        expect{ patch :update, params: { id: @ingredient.id, ingredient: ingredient_params } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @ingredient = create(:ingredient, user_id: @user.id)
      end

      it 'returns a 302 response' do
        ingredient_params = attributes_for(:ingredient)
        patch :update, params: { id: @ingredient.id, ingredient: ingredient_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        ingredient_params = attributes_for(:ingredient)
        patch :update, params: { id: @ingredient.id, ingredient: ingredient_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @ingredient = create(:ingredient, user_id: @user.id)
        sign_in @user
        @user.confirm
      end

      it 'deletes an ingredient' do
        expect { delete :destroy, params: { id: @ingredient.id } }
          .to change(@user.ingredients, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @ingredient = create(:ingredient, user_id: other_user.id)
        sign_in @user
        @user.confirm
      end

      it 'does not delete the ingredient' do
        expect { delete :destroy, params: { id: @ingredient.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @ingredient = create(:ingredient, user_id: @user.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @ingredient.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @ingredient.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the ingredient' do
        expect { delete :destroy, params: { id: @ingredient.id } }
          .to_not change(Ingredient, :count)
      end
    end
  end
end
