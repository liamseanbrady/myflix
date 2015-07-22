describe UsersController do
  describe 'GET new' do
    it 'sets @user to a new user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    describe 'POST create' do
      context 'valid input' do
        it 'creates a user' do
          post :create, user: Fabricate.attributes_for(:user)

          expect(User.count).to eq(1)
        end

        it_behaves_like 'requires sign in' do
          let(:action) { post :create, user: Fabricate.attributes_for(:user) }
        end
      end
    end

    context 'invalid input' do
      it 'does not create a user' do
        post :create, user: { email: 'anon@example.com' }

        expect(User.count).to eq(0)
      end

      it 'renders the view template' do
        post :create, user: { email: 'anon@example.com' }

        expect(response).to render_template :new
      end
    end

    context 'sending email' do
      after { ActionMailer::Base.deliveries.clear }
      
      it 'sends out email to the user with valid inputs' do
        post :create, user: { full_name: 'Alice', email: 'alice@example.com', password: 'password' }

        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { full_name: 'Alice', email: 'alice@example.com', password: 'password' }

        expect(ActionMailer::Base.deliveries.last.body).to include("Alice")
      end

      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'alice@example.com' }

        expect(ActionMailer::Base.deliveries).to be_empty
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
end
