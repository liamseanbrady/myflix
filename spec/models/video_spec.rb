require 'spec_helper'

describe Video do
  it 'belongs to a category' do
    comedies = Category.create(name: 'Comedies')
    video = Video.new(title: 'Fringe',
                      description: 'An awesome show',
                      small_cover_url: '/tmp/fringe.jpg',
                      large_cover_url: '/tmp/fringe.jpg',
                      category: comedies)
    
    expect(video.category).to eq(comedies)
  end

  it 'must have a title to be saved' do
    comedies = Category.create(name: 'comedies')
    video = Video.new(description: 'An awesome show',
                      small_cover_url: '/tmp/fringe.jpg',
                      large_cover_url: '/tmp/fringe.jpg',
                      category: comedies)
    
    expect(Video.count).to eq(0)
  end

  it 'must have a description to be saved' do
    comedies = Category.create(name: 'comedies')
    video = Video.new(title: 'Fringe',
                      small_cover_url: '/tmp/fringe.jpg',
                      large_cover_url: '/tmp/fringe.jpg',
                      category: comedies)
       
    expect(Video.count).to eq(0)
  end
end
