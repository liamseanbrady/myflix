require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it 'sets @video for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)

      get :show, id: video.id 

      expect(assigns(:video)).to eq(video)
    end
    it 'redirects to sign in path for unauthenticated users' do
      get :show, id: Fabricate(:video).id
      
      expect(response).to redirect_to sign_in_path
    end
  end
end
