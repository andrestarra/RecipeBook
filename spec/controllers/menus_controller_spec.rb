require 'rails_helper'

RSpec.describe MenusController, type: :controller do
  describe '#index' do
    context "as an authenticated user" do
      before do
        @user = create(:user)
        sign_in @user
        @user.confirm
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
        expect(assigns(:menus)).to be_empty
      end

      it 'assigns menu arrays' do
        get :index
        @menu = create_list(:menu, 10, user_id: @user.id)
        expect(assigns(:menus).count).to eq 10
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
        sign_in @user
        @user.confirm
      end

      it 'responds successfully' do
        get :show, params: { id: @menu.id }
        expect(response).to be_successful
      end

      it 'no show with a nonexistent menu' do
        expect{ get :show, params: { id: 500 } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: other_user.id)
        sign_in @user
        @user.confirm
      end

      it 'record not found to unauthorized user' do
        expect{ get :show, params: { id: @menu.id } }
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

    it 'assigns a new menu' do
      get :new
      expect(assigns(:menu)).to be_a_new(Menu)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @menu = create(:menu, user_id: @user.id)
      sign_in @user
      @user.confirm
    end

    it 'render edit template' do
      get :edit, params: { id: @menu.id }
      expect(response).to render_template(:edit)
    end

    it 'load menu params in edit template' do
      get :edit, params: { id: @menu.id }
      expect(assigns(:menu)).to eq(@menu)
    end

    it 'no load with a nonexistent menu' do
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
        it 'adds a menu' do
          menu_params = attributes_for(:menu).merge(user_id: @user.id)
          expect { post :create, params: { menu: menu_params } }
            .to change(@user.menus, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add an menu' do
          menu_params = attributes_for(:menu, :invalid)
          expect { post :create, params: { menu: menu_params } }
            .to_not change(@user.menus, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        menu_params = attributes_for(:menu)
        post :create, params: { menu: menu_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        menu_params = attributes_for(:menu)
        post :create, params: { menu: menu_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        sign_in @user
        @user.confirm
      end

      it 'updates an menu' do
        menu_params = attributes_for(:menu, :new_name)
        patch :update, params: { id: @menu.id, menu: menu_params }
        expect(@menu.reload.name).to eq 'New menu'
      end

      it 'can not update an menu' do
        menu_params = attributes_for(:menu, :invalid)
        patch :update, params: { id: @menu.id, menu: menu_params }
        expect(@menu.reload.name).to eq @menu.name
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: other_user.id)
        sign_in @user
        @user.confirm
      end

      it 'does not update the menu' do
        menu_params = attributes_for(:menu, :new_name)
        expect{ patch :update, params: { id: @menu.id, menu: menu_params } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
      end

      it 'returns a 302 response' do
        menu_params = attributes_for(:menu)
        patch :update, params: { id: @menu.id, menu: menu_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        menu_params = attributes_for(:menu)
        patch :update, params: { id: @menu.id, menu: menu_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    describe '#destroy' do
      context 'as an authorized user' do
        before do
          @user = create(:user)
          @menu = create(:menu, user_id: @user.id)
          sign_in @user
          @user.confirm
        end
  
        it 'deletes an menu' do
          expect { delete :destroy, params: { id: @menu.id } }
            .to change(@user.menus, :count).by(-1)
        end
      end
  
      context 'as an unauthorized user' do
        before do
          @user = create(:user)
          other_user = create(:user)
          @menu = create(:menu, user_id: other_user.id)
          sign_in @user
          @user.confirm
        end
  
        it 'does not delete the menu' do
          expect { delete :destroy, params: { id: @menu.id } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
  
      context 'as a guest' do
        before do
          @user = create(:user)
          @menu = create(:menu, user_id: @user.id)
        end
  
        it 'returns a 302 response' do
          delete :destroy, params: { id: @menu.id }
          expect(response).to have_http_status '302'
        end
  
        it 'redirects to the sign-in page' do
          delete :destroy, params: { id: @menu.id }
          expect(response).to redirect_to '/users/sign_in'
        end
  
        it 'does not delete the plate' do
          expect { delete :destroy, params: { id: @menu.id } }
            .to_not change(Menu, :count)
        end
      end
    end
  end
end
