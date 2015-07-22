require 'spec_helper'

describe User do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:full_name) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to have_many(:queue_items).order(:position) }
  it { is_expected.to have_many(:reviews).order(created_at: :desc) }
  it { is_expected.to have_many(:following_relationships) }
  it { is_expected.to have_many(:leading_relationships) }

  describe '#queued_video' do
    it 'returns false when the user has not queued the video' do
      video = Fabricate(:video)
      alice = Fabricate(:user)

      expect(alice.queued_video?(video)).to eq(false)
    end

    it 'returns true when the user has queued the video' do
      alice = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: alice)

      expect(alice.queued_video?(video)).to eq(true)
    end
  end

  describe '#follows?' do
    it 'returns true if the user has a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)

      expect(alice.follows?(bob)).to be true
    end

    it 'returns false if the user does not have a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)

      expect(alice.follows?(bob)).to be false
    end
  end

  describe '#can_follow?' do
    it 'returns false if the current user already has a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)

      expect(alice.can_follow?(bob)).to be false
    end
    
    it 'returns false if the current user is trying to have a following relationship with themself' do
      alice = Fabricate(:user)

      expect(alice.can_follow?(alice)).to be false
    end

    it 'returns true if the current user does not have a following relationship with another user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)

      expect(alice.can_follow?(bob)).to be true
    end
  end

end
