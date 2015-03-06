require 'spec_helper'

describe Category do
  it 'has many videos' do
    sci_fi = Category.create(name: 'Sci-fi')

    fringe = Video.create(title: 'Fringe',
                          description: 'An awesome show',
                          small_cover_url: 'x.jpg',
                          large_cover_url: 'x.jpg',
                          category: sci_fi)
    star_trek = Video.create(title: 'Fringe',
                             description: 'An good show',
                             small_cover_url: 'x.jpg',
                             large_cover_url: 'x.jpg',
                             category: sci_fi)
                          
    expect(sci_fi.videos).to eq([fringe, star_trek])
  end
end
