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
  end
end
