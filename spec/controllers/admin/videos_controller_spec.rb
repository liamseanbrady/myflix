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

      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
  end
end
