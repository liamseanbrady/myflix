require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items for the authenticated user' do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      queue_item_one = Fabricate(:queue_item, user: alice)
      queue_item_two = Fabricate(:queue_item, user: alice)

      get :index

      expect(assigns(:queue_items)).to match_array([queue_item_one, queue_item_two])
    end

    it 'redirects to sign in path for unauthenticated users' do
      get :index

      expect(response).to redirect_to sign_in_path
    end
  end
  
  describe 'POST create' do
    context 'for authenticated users' do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
      end

      it 'creates a queue item' do
        video = Fabricate(:video)

        post :create, video_id: video.id 
        
        expect(QueueItem.count).to eq(1)
      end

      it 'creates a queue item that is associated with the video' do
        video = Fabricate(:video)

        post :create, video_id: video.id 
        
        expect(QueueItem.first.video).to eq(video)
      end

      it 'creates a queue item that is associated with the user' do
        video = Fabricate(:video)

        post :create, video_id: video.id 
        
        expect(QueueItem.first.user).to eq(alice)
      end

      it 'puts the video as the last one in the queue' do
        video = Fabricate(:video)
        queue_item_one = Fabricate(:queue_item)

        post :create, video_id: video.id 
        
        expect(QueueItem.last.position).to eq(2)
      end

      it 'does not create add the video to the queue if it is already in the queue' do
        video = Fabricate(:video)
        Fabricate(:queue_item, video: video, user: alice)

        post :create, video_id: video.id 
        
        expect(QueueItem.count).to eq(1)
      end
      
      it 'redirects to the my queue page' do
        video = Fabricate(:video)

        post :create, video_id: video.id

        expect(response).to redirect_to my_queue_path
      end
    end
  end

  describe 'DELETE destroy' do
    context 'for authenticated users' do
      let(:alice) { Fabricate(:user) }
      before do
        session[:user_id] = alice.id
      end
      
      it 'removes the video from the queue' do
        queue_item = Fabricate(:queue_item, user: alice)
        
        delete :destroy, id: queue_item.id

        expect(QueueItem.count).to eq(0)
      end

      it 'does not remove the queue item if the current user does not own it' do
        queue_item = Fabricate(:queue_item, user: Fabricate(:user))
        
        delete :destroy, id: queue_item.id

        expect(QueueItem.count).to eq(1)
      end

      it 'redirects to the my queue page' do
        queue_item = Fabricate(:queue_item)
        
        delete :destroy, id: queue_item.id

        expect(response).to redirect_to my_queue_path
      end
    end
    
    context 'for unauthenticated users' do
      it 'redirects to sign in page' do
        delete :destroy, id: 1

        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
