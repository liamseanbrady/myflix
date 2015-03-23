require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'renders :new template for unauthenticated users' do
      get :new

      expect(response).to render_template :new
    end
    it 'redirects_to home path for authenticated users' do
      session[:user_id] = Fabricate(:user).id

      get :new

      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    context 'with valid credentials' do
      let(:alice) { Fabricate(:user) }

      before do
        post :create, email: alice.email, password: alice.password 
      end

      it 'redirects to the home page' do
        expect(response).to redirect_to home_path
      end

      it 'sets the session for the user' do
        expect(session[:user_id]).to eq(alice.id)
      end

      it 'sets the flash success message' do
        expect(flash[:success]).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      let(:alice) { Fabricate(:user) }

      before do
        post :create, email: alice.email, password: alice.password + 'adsdf'
      end

      it 'does not set the session for the user' do
        expect(session[:user_id]).to be_nil
      end
      it 'sets the flash danger message' do
        expect(flash[:danger]).not_to be_nil
      end
      it 'redirects to the sign in page' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
