require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it "sets @relationships to the current user's following relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)

      get :index

      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the relationship if the current user is the follower' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      
      delete :destroy, id: relationship.id

      expect(Relationship.all.count).to eq(0)
    end

    it 'does not delete the relationship if the current user is not the follower' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      chris = Fabricate(:user)
      set_current_user(chris)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      
      delete :destroy, id: relationship.id

      expect(Relationship.all.count).to eq(1)
    end

    it 'redirects to the people page' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      
      delete :destroy, id: relationship.id

      expect(response).to redirect_to people_path
    end

    it_behaves_like 'requires sign in' do
      let(:action) { delete :destroy, id: 1 }
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create, leader_id: 1 }
    end

    it 'redirects to the people page' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)

      post :create, leader_id: bob.id

      expect(response).to redirect_to people_path
    end

    it 'creates a relationship where the current user is the follower' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)

      post :create, leader_id: bob.id

      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it 'does not create a relationship if that relationship already exists' do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)

      post :create, leader_id: bob.id

      expect(Relationship.count).to eq(1)
    end

    it 'does not allow a user to follow themself' do 
      alice = Fabricate(:user)
      set_current_user(alice)

      post :create, leader_id: alice.id

      expect(Relationship.count).to eq(0)
    end
  end
end
