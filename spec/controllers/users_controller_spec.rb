describe UsersController do
  describe 'GET new' do
    it 'sets @user to a new user' do
      get :new

      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST create' do
    context 'with valid personal info and valid card' do
      let(:charge) { double('charge', successful?: true) }
      before { StripeWrapper::Charge.should_receive(:create).and_return(charge) }

      it 'creates a user' do
        post :create, user: Fabricate.attributes_for(:user)
          
        expect(User.count).to eq(1)
      end

      it_behaves_like 'requires sign in' do
        let(:action) { post :create, user: Fabricate.attributes_for(:user) }
      end

      it 'makes the user follow the inviter' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')

        post :create, user: Fabricate.attributes_for(:user, email: 'bob@example.com'), invitation_token: invitation.token

        bob = User.find_by(email: 'bob@example.com')
        expect(bob.follows?(alice)).to be_truthy
      end

      it 'makes the inviter follow the user' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')

        post :create, user: Fabricate.attributes_for(:user, email: 'bob@example.com'), invitation_token: invitation.token

        bob = User.find_by(email: 'bob@example.com')
        expect(alice.follows?(bob)).to be_truthy
      end

      it 'expires the invitation upon acceptance' do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'bob@example.com')

        post :create, user: Fabricate.attributes_for(:user, email: 'bob@example.com'), invitation_token: invitation.token

        expect(invitation.reload.token).to be_nil
      end
    end

    context 'with valid personal info and declined card' do
      it 'does not create a new user record' do
        charge = double('charge', successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)

        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'ab1234'

        expect(User.count).to eq(0)
      end

      it 'renders the new template' do
        charge = double('charge', successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)

        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'ab1234'

        expect(response).to render_template :new
      end

      it 'sets the flash danger message' do
        charge = double('charge', successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)

        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'ab1234'

        expect(flash.now[:danger]).to be_present
      end
    end

    context 'with invalid personal info' do
      before { StripeWrapper::Charge.should_not_receive(:create) }

      it 'does not create a user' do
        post :create, user: { email: 'anon@example.com' }

        expect(User.count).to eq(0)
      end

      it 'renders the view template' do
        post :create, user: { email: 'anon@example.com' }

        expect(response).to render_template :new
      end

      it 'does not charge the card' do
        post :create, user: { email: 'anon@example.com' }
      end

      it 'does not send out email with invalid inputs' do
        ActionMailer::Base.deliveries.clear

        post :create, user: { email: 'alice@example.com' }

        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'when sending email' do
      let(:charge) { double('charge', successful?: true) }
      before do 
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        ActionMailer::Base.deliveries.clear
      end
      
      it 'sends out email to the user with valid inputs' do
        post :create, user: { full_name: 'Alice', email: 'alice@example.com', password: 'password' }

        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { full_name: 'Alice', email: 'alice@example.com', password: 'password' }

        expect(ActionMailer::Base.deliveries.last.body).to include("Alice")
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
