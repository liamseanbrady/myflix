require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'renders the reset password page if the token is valid' do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')

      get :show, id: '12345'

      expect(response).to render_template :show
    end

    it 'sets @token' do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')

      get :show, id: '12345'

      expect(assigns(:token)).to eq('12345')
    end

    it 'redirects to expired token path if the token is invalid' do
      get :show, id: 'badtoken'

      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      it 'resets the password for a user' do
        alice = Fabricate(:user, password: 'oldpassword')
        alice.update_column(:token, '12345')

        post :create, token: '12345', password: 'newpassword'

        expect(alice.reload.authenticate('newpassword')).to be_truthy
      end


      it 'redirects to sign in page' do
        alice = Fabricate(:user, password: 'oldpassword')
        alice.update_column(:token, '12345')

        post :create, token: '12345', password: 'newpassword'

        expect(response).to redirect_to sign_in_path
      end

      it 'sets a success message' do
        alice = Fabricate(:user, password: 'oldpassword')
        alice.update_column(:token, '12345')

        post :create, token: '12345', password: 'newpassword'

        expect(flash[:success]).to be_present
      end
      
      it 'regenerates the token for that user' do
        alice = Fabricate(:user, password: 'oldpassword')
        alice.update_column(:token, '12345')

        post :create, token: '12345', password: 'newpassword'

        expect(alice.reload.token).not_to eq('12345')
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired token path' do
        post :create, token: '12345', password: 'somepassword'

        expect(response).to redirect_to expired_token_path
      end

      it 'does not reset the password for a user' do
        alice = Fabricate(:user, password: 'oldpassword')
        alice.update_column(:token, '12345')

        post :create, token: '12345', password: ''

        expect(alice.reload.password).to eq('oldpassword')
      end

      it 'does not regenerate the token for that user' do
        alice = Fabricate(:user, password: 'oldpassword')
        alice.update_column(:token, '12345')

        post :create, token: '12345', password: ''

        expect(alice.reload.token).to eq('12345')
      end
    end
  end
end
