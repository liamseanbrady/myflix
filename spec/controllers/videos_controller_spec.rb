require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video for authenticated users' do
      set_current_user
      video = Fabricate(:video)

      get :show, id: video.id 

      expect(assigns(:video)).to eq(video)
    end

    it 'sets @reviews for authenticated users' do
      set_current_user
      video = Fabricate(:video)
      review_one = Fabricate(:review, video: video)
      review_two = Fabricate(:review, video: video)

      get :show, id: video.id 

      expect(assigns(:reviews)).to match_array([review_one, review_two])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :show, id: Fabricate(:video).id }
    end
  end

  describe 'GET search' do
    it 'sets @results for authenticated users' do
      set_current_user
      video = Fabricate(:video)

      get :search, search_term: video.title

      expect(assigns(:results)).to match_array([video])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :search, search_term: '' }
    end
  end
end
