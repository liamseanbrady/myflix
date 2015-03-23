require 'spec_helper'

describe Video do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to have_many(:reviews) }

  describe '.search_by_title' do
    it 'returns an empty array if there is no match' do
      fringe = Video.create(title: 'Fringe',
                            description: 'A sci-fi show')
      back_to_the_future = Video.create(title: 'Back to the Future',
                                        description: 'A good movie')

      expect(Video.search_by_title('hello')).to eq([])
    end
    
    it 'returns an array of one video for one match' do
      fringe = Video.create(title: 'Fringe',
                            description: 'A sci-fi show')
      back_to_the_future = Video.create(title: 'Back to the Future',
                                        description: 'A good movie')

      expect(Video.search_by_title('Fringe')).to eq([fringe])
    end
    
    it 'returns an array of one video for a partial match' do
      fringe = Video.create(title: 'Fringe',
                            description: 'A sci-fi show')
      back_to_the_future = Video.create(title: 'Back to the Future',
                                        description: 'A good movie')

      expect(Video.search_by_title('ring')).to eq([fringe])
    end
    
    it 'returns an array of all matches ordered by created_at' do
      fringe = Video.create(title: 'Fringe',
                            description: 'A sci-fi show',
                            created_at: 1.day.ago)
      back_to_the_future = Video.create(title: 'Back to the Future',
                                        description: 'A good movie')

      expect(Video.search_by_title('F')).to eq([back_to_the_future, fringe])
    end

    it 'returns an empty array for a seatch with an empty string' do
      fringe = Video.create(title: 'Fringe',
                            description: 'A sci-fi show')
      back_to_the_future = Video.create(title: 'Back to the Future',
                                        description: 'A good movie')

      expect(Video.search_by_title('')).to eq([])
    end
  end
end
