require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end

    it 'sets @video to a new video' do
      set_current_admin

      get :new

      expect(assigns(:video)).to be_present
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires admin' do
      let(:action) { post :create }
    end


    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      let(:category) { category = Fabricate(:category) }

      before do
        set_current_admin
        post :create, video: { title: 'Fringe', description: 'A good show', category_id: category.id }
      end

      it 'creates a video' do
        expect(category.videos.count).to eq(1)
      end

      it 'redirects to the add new video page' do
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets the flash success message' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      let(:category) { category = Fabricate(:category) }

      before do
        set_current_admin
        post :create, video: { title: '', description: 'A good show', category_id: category.id }
      end

      it 'does not create video' do
        expect(Video.count).to eq(0)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end

      it 'sets the flash error message' do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
