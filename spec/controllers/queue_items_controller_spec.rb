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
end
