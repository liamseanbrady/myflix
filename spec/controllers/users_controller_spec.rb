require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user to a new user' do
      get :new

      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context 'with successful user registration' do
      it 'redirects to the sign in page' do
        result = double('result', successful?: true)
        UserRegistration.any_instance.should_receive(:register).and_return(result)

        post :create, user: Fabricate.attributes_for(:user)
        
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with failed user registration' do
      let(:result) { double('result', successful?: false, error_message: 'Error message') }
      before { UserRegistration.any_instance.should_receive(:register).and_return(result) }

      it 'renders the new template' do
        post :create, user: { email: 'anon@example.com' }

        expect(response).to render_template :new
      end

      it 'sets the flash danger message' do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'ab1234'

        expect(flash.now[:danger]).to eq('Error message')
      end
    end
  end

  describe 'GET show' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: 1 }
    end

    it 'sets @user' do
      alice = Fabricate(:user)
      set_current_user(alice)

      get :show, id: alice.id

      expect(assigns(:user)).to eq(alice)
    end
  end

  describe 'GET new_with_invitation_token' do
    it 'renders the :new template' do
      invitation = Fabricate(:invitation)

      get :new_with_invitation_token, token: invitation.token

      expect(response).to render_template :new
    end

    it "sets @user to a new user with the recipient's email" do
      invitation = Fabricate(:invitation)

      get :new_with_invitation_token, token: invitation.token

      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it 'sets @invitation_token' do
      invitation = Fabricate(:invitation)

      get :new_with_invitation_token, token: invitation.token

      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it 'redirects to expired token page for invalid tokens' do
      get :new_with_invitation_token, token: 'abcde'

      expect(response).to redirect_to expired_token_path
    end
  end
end
