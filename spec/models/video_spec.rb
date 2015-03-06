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
end
