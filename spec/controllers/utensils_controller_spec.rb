require 'rails_helper'

RSpec.describe UtensilsController, type: :controller do
  describe '#index' do
    context "as an authenticated user" do
      before do
        @user = create(:user)
        sign_in @user
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
        expect(assigns(:utensils)).to be_empty
      end

      it 'assigns utensils arrays' do
        get :index
        @utensils = create_list(:utensil, 10, user_id: @user.id)
        expect(assigns(:utensils).count).to eq 10
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
        @utensil = create(:utensil, user_id: @user.id)
        sign_in @user
      end

      it 'responds successfully' do
        get :show, params: { id: @utensil.id }
        expect(response).to be_successful
      end

      it 'no show with a nonexistent utensil' do
        expect{ get :show, params: { id: 500 } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @utensil = create(:utensil, user_id: other_user.id)
        sign_in @user
      end

      it 'record not found to unauthorized user' do
        expect{ get :show, params: { id: @utensil.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#new' do
    before do
      @user = create(:user)
      sign_in @user
    end

    it 'render the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new utensil' do
      get :new
      expect(assigns(:utensil)).to be_a_new(Utensil)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @utensil = create(:utensil, user_id: @user.id)
      sign_in @user
    end

    it 'render edit template' do
      get :edit, params: { id: @utensil.id }
      expect(response).to render_template(:edit)
    end

    it 'load utensil params in edit template' do
      get :edit, params: { id: @utensil.id }
      expect(assigns(:utensil)).to eq(@utensil)
    end

    it 'no load with a nonexistent utensil' do
      expect { get :edit, params: { id: 500 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'as an autheticated user' do
      before do
        @user = create(:user)
        sign_in @user
      end

      context 'with valid attributes' do
        it 'adds a utensil' do
          utensil_params = attributes_for(:utensil).merge(user_id: @user.id)
          expect { post :create, params: { utensil: utensil_params } }
            .to change(@user.utensils, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add an utensil' do
          utensil_params = attributes_for(:utensil, :invalid)
          expect { post :create, params: { utensil: utensil_params } }
            .to_not change(@user.utensils, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        utensil_params = attributes_for(:utensil)
        post :create, params: { utensil: utensil_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        utensil_params = attributes_for(:utensil)
        post :create, params: { utensil: utensil_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @utensil = create(:utensil, user_id: @user.id)
        sign_in @user
      end

      it 'updates an utensil' do
        utensil_params = attributes_for(:utensil, :new_name)
        patch :update, params: { id: @utensil.id, utensil: utensil_params }
        expect(@utensil.reload.name).to eq 'New utensil'
      end

      it 'can not update an utensil' do
        utensil_params = attributes_for(:utensil, :invalid)
        patch :update, params: { id: @utensil.id, utensil: utensil_params }
        expect(@utensil.reload.name).to eq @utensil.name
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @utensil = create(:utensil, user_id: other_user.id)
        sign_in @user
      end

      it 'does not update the utensil' do
        utensil_params = attributes_for(:utensil, :new_name)
        expect{ patch :update, params: { id: @utensil.id, utensil: utensil_params } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @utensil = create(:utensil, user_id: @user.id)
      end

      it 'returns a 302 response' do
        utensil_params = attributes_for(:utensil)
        patch :update, params: { id: @utensil.id, utensil: utensil_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        utensil_params = attributes_for(:utensil)
        patch :update, params: { id: @utensil.id, utensil: utensil_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @utensil = create(:utensil, user_id: @user.id)
        sign_in @user
      end

      it 'deletes an utensil' do
        expect { delete :destroy, params: { id: @utensil.id } }
          .to change(@user.utensils, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @utensil = create(:utensil, user_id: other_user.id)
        sign_in @user
      end

      it 'does not delete the utensil' do
        expect { delete :destroy, params: { id: @utensil.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @utensil = create(:utensil, user_id: @user.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @utensil.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @utensil.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the utensil' do
        expect { delete :destroy, params: { id: @utensil.id } }
          .to_not change(Utensil, :count)
      end
    end
  end
end
