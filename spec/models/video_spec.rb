require 'spec_helper'

describe Video do
  it 'saves itself' do
    video = Video.new(title: 'Fringe',
                      description: 'An awesome show',
                      small_cover_url: '/tmp/fringe.jpg',
                      large_cover_url: '/tmp/fringe.jpg')
    video.save

    expect(Video.first).to eq(video)
  end

  it 'belongs to a category' do
    comedies = Category.create(name: 'Comedies')
    video = Video.new(title: 'Fringe',
                      description: 'An awesome show',
                      small_cover_url: '/tmp/fringe.jpg',
                      large_cover_url: '/tmp/fringe.jpg',
                      category: comedies)
    
    expect(video.category).to eq(comedies)
  end
end
