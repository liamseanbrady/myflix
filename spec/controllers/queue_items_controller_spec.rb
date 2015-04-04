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

  describe 'POST update_queue' do
    context 'with valid input' do
      it 'redirects to the my queue page' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: alice, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 2}, { id: queue_item_two.id, position: 1}]

        expect(response).to redirect_to my_queue_path
      end

      it 'reorders the queue items' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: alice, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 2 }, { id: queue_item_two.id, position: 1 }]

        expect(alice.queue_items).to eq([queue_item_two, queue_item_one])
      end
      it 'normalizes the position numbers' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: alice, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 3 }, { id: queue_item_two.id, position: 2 }]

        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end
    context 'with invalid input' do
      it 'redirects to my queue page' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: alice, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 3 }, { id: queue_item_two.id, position: 2.35 }]

        expect(response).to redirect_to my_queue_path
      end

      it 'sets the flash danger message' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: alice, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 3 }, { id: queue_item_two.id, position: 2.35 }]

        expect(flash[:danger]).to be_present
      end

      it 'does not reorder the queue items' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: alice, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 3 }, { id: queue_item_two.id, position: 2.35 }]

        expect(queue_item_one.reload.position).to eq(1)
      end
    end

    context 'for unauthenticated users' do
      it 'redirects to the sign in page' do
        post :update_queue, queue_items: [{ id: 1, position: 3 }, { id: 2, position: 2 }]

        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with queue items that do not belong to the current user' do
      it 'redirects to my queue page' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        bob = Fabricate(:user)
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: bob, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 2 }, { id: queue_item_two.id, position: 1 }]

        expect(response).to redirect_to my_queue_path
      end
      it 'does not reorder queue items that do not belong to the current user' do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        bob = Fabricate(:user)
        queue_item_one = Fabricate(:queue_item, user: alice, position: 1)
        queue_item_two = Fabricate(:queue_item, user: bob, position: 2)

        post :update_queue, queue_items: [{ id: queue_item_one.id, position: 2 }, { id: queue_item_two.id, position: 1 }]

        expect(queue_item_two.reload.position).to eq(2)
      end
    end
  end
end
