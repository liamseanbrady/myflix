require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'for authenticated users' do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
      end

      context 'with valid input' do
        let(:video) { Fabricate(:video) }
        before do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it 'redirects to video show page' do
          expect(response).to redirect_to video
        end
        
        it 'creates a review' do
          expect(Review.count).to eq(1)
        end
        
        it 'creates a review for the associated video' do
          expect(Review.first.video).to eq(video)
        end

        it 'it creates a review associated to the current_user' do
          expect(Review.first.author).to eq(alice)
        end
      end

      context 'with invalid input' do
        let(:video) { Fabricate(:video) }

        it 'does not create a review' do
          post :create, review: Fabricate.attributes_for(:review, content: ''), video_id: video.id
          
          expect(Review.count).to eq(0)
        end

        it 'renders the video show page' do
          post :create, review: Fabricate.attributes_for(:review, content: ''), video_id: video.id
          
          expect(response).to render_template 'videos/show'
        end

        it 'sets @video' do
          post :create, review: Fabricate.attributes_for(:review, content: ''), video_id: video.id
          
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @reviews' do
          review = Fabricate(:review, video: video)

          post :create, review: Fabricate.attributes_for(:review, content: ''), video_id: video.id

          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context 'for unauthenticated users' do
      it 'redirects to the sign in path' do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review, content: ''), video_id: video.id
        
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
