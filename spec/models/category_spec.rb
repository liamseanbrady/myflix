require 'spec_helper'

describe Category do
  it { is_expected.to have_many(:videos) }

  describe '#recent_videos' do
    it 'returns all videos ordered by reverse chorological order by created_at' do
      sci_fi = Category.create(name: 'Sci-fi')
      fringe = Video.create(title: 'Fringe', 
                            description: 'A good show',
                            category: sci_fi,
                            created_at: 1.day.ago)
      futurama = Video.create(title: 'Fringe', 
                              description: 'A good show',
                              category: sci_fi)
       
      expect(sci_fi.recent_videos).to eq([futurama, fringe])
    end

    it 'returns all the videos if there are less than 6 videos' do
      sci_fi = Category.create(name: 'Sci-fi')
      fringe = Video.create(title: 'Fringe', 
                            description: 'A good show',
                            category: sci_fi,
                            created_at: 1.day.ago)
      futurama = Video.create(title: 'Fringe', 
                              description: 'A good show',
                              category: sci_fi)
       
      expect(sci_fi.recent_videos.count).to eq(2)
    end

    it 'returns 6 videos when a category has more than 6 videos' do
      sci_fi = Category.create(name: 'Sci-fi')
      7.times do
        Video.create(title: 'A Sci-fi Movie', 
                     description: "It's a movie!",
                     category: sci_fi)
      end
      
      expect(sci_fi.recent_videos.count).to eq(6)
    end
    it 'returns the most recent 6 videos' do
      sci_fi = Category.create(name: 'Sci-fi')
      6.times do
        Video.create(title: 'A Sci-fi Movie', 
                     description: "It's a movie!",
                     category: sci_fi)
      end
      old_video = Video.create(title: 'Star Trek',
                               description: 'An old one',
                               category: sci_fi,
                               created_at: 1.day.ago)

      expect(sci_fi.recent_videos).not_to include(old_video)
    end

    it 'returns an empty array when the category has no videos' do
      sci_fi = Category.create(name: 'Sci-fi')

      expect(sci_fi.recent_videos).to eq([])
    end
  end
end
