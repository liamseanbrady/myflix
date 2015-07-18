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
end
