require 'rails_helper'

RSpec.describe PlatesController, type: :controller do
  describe '#index' do
    context "as an authenticated user" do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
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
        expect(assigns(:plates)).to be_empty
      end

      it 'assigns plate arrays' do
        get :index
        @plate = create_list(:plate, 10, user_id: @user.id, menu_id: @menu.id)
        expect(assigns(:plates).count).to eq 10
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
        sign_in @user
      end

      it 'responds successfully' do
        get :show, params: { id: @plate.id }
        expect(response).to be_successful
      end

      it 'no show with a nonexistent plate' do
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
        sign_in @user
      end

      it 'record not found to unauthorized user' do
        expect{ get :show, params: { id: @plate.id } }
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

    it 'assigns a new plate' do
      get :new
      expect(assigns(:plate)).to be_a_new(Plate)
    end
  end

  describe '#edit' do
    before do
      @user = create(:user)
      @menu = create(:menu, user_id: @user.id)
      @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
      sign_in @user
    end

    it 'render edit template' do
      get :edit, params: { id: @plate.id }
      expect(response).to render_template(:edit)
    end

    it 'load plate params in edit template' do
      get :edit, params: { id: @plate.id }
      expect(assigns(:plate)).to eq(@plate)
    end

    it 'no load with a nonexistent plate' do
      expect { get :edit, params: { id: 500 } }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create' do
    context 'as an autheticated user' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        sign_in @user
      end

      context 'with valid attributes' do
        it 'adds a plate' do
          plate_params = attributes_for(:plate).merge(user_id: @user.id, menu_id: @menu.id)
          expect { post :create, params: { plate: plate_params } }
            .to change(@user.plates, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add an plate' do
          plate_params = attributes_for(:plate, :invalid)
          expect { post :create, params: { plate: plate_params } }
            .to_not change(@user.plates, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        plate_params = attributes_for(:plate)
        post :create, params: { plate: plate_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        plate_params = attributes_for(:plate)
        post :create, params: { plate: plate_params }
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
        sign_in @user
      end

      it 'updates an plate' do
        plate_params = attributes_for(:plate, :new_name)
        patch :update, params: { id: @plate.id, plate: plate_params }
        expect(@plate.reload.name).to eq 'New plate'
      end

      it 'can not update an plate' do
        plate_params = attributes_for(:plate, :invalid)
        patch :update, params: { id: @plate.id, plate: plate_params }
        expect(@plate.reload.name).to eq @plate.name
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        sign_in @user
      end

      it 'does not update the plate' do
        plate_params = attributes_for(:plate, :new_name)
        expect{ patch :update, params: { id: @plate.id, plate: plate_params } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
      end

      it 'returns a 302 response' do
        plate_params = attributes_for(:plate)
        patch :update, params: { id: @plate.id, plate: plate_params }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        plate_params = attributes_for(:plate)
        patch :update, params: { id: @plate.id, plate: plate_params }
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
        sign_in @user
      end

      it 'deletes an plate' do
        expect { delete :destroy, params: { id: @plate.id } }
          .to change(@user.plates, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = create(:user)
        other_user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: other_user.id, menu_id: @menu.id)
        sign_in @user
      end

      it 'does not delete the plate' do
        expect { delete :destroy, params: { id: @plate.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'as a guest' do
      before do
        @user = create(:user)
        @menu = create(:menu, user_id: @user.id)
        @plate = create(:plate, user_id: @user.id, menu_id: @menu.id)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @plate.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @plate.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the plate' do
        expect { delete :destroy, params: { id: @plate.id } }
          .to_not change(Plate, :count)
      end
    end
  end
end
