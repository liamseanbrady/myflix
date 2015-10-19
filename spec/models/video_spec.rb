require 'spec_helper'

describe Video do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to have_many(:reviews) }

  describe '.search_by_title' do
    it 'returns an empty array if there is no match' do
      fringe = Fabricate(:video, title: 'Fringe')
      back_to_the_future = Fabricate(:video, title: 'Futurama')

      expect(Video.search_by_title('hello')).to eq([])
    end
    
    it 'returns an array of one video for one match' do
      fringe = Fabricate(:video, title: 'Fringe')
      back_to_the_future = Fabricate(:video, title: 'Futurama')

      expect(Video.search_by_title('Fringe')).to eq([fringe])
    end
    
    it 'returns an array of one video for a partial match' do
      fringe = Fabricate(:video, title: 'Fringe')
      back_to_the_future = Fabricate(:video, title: 'Futurama')

      expect(Video.search_by_title('ring')).to eq([fringe])
    end
    
    it 'returns an array of all matches ordered by created_at' do
      fringe = Fabricate(:video, title: 'Fringe')
      back_to_the_future = Fabricate(:video, title: 'Back to the Future')

      expect(Video.search_by_title('F')).to eq([back_to_the_future, fringe])
    end

    it 'returns an empty array for a seatch with an empty string' do
      fringe = Fabricate(:video, title: 'Fringe')
      back_to_the_future = Fabricate(:video, title: 'Back to the Future')

      expect(Video.search_by_title('')).to eq([])
    end
  end

  describe '#rating' do
    it 'returns 0.0 if the video has no ratings' do
      fringe = Fabricate(:video)

      expect(fringe.rating).to be_nil
    end
    
    it 'returns the rating for a video with only one rating to one decimal place' do
      fringe = Fabricate(:video)
      review = Fabricate(:review, rating: 5, video: fringe)

      expect(fringe.rating).to eq(5.0)
    end

    it 'returns the average rating of two videos to one decimal place' do
      fringe = Fabricate(:video)
      Fabricate(:review, rating: 5, video: fringe)
      Fabricate(:review, rating: 4, video: fringe)

      expect(fringe.rating).to eq(4.5)
    end
  end
end
