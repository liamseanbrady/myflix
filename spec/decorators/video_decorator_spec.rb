require 'spec_helper'

describe VideoDecorator do
  describe '#rating' do
    it 'returns N/A when there are no reviews present' do
      fringe = Fabricate(:video)
      fringe_decorator = VideoDecorator.decorate(fringe)

      expect(fringe_decorator.rating).to eq('N/A')
    end

    it 'returns the average rating out of 5.0 with existing reviews' do
      fringe = Fabricate(:video)
      Fabricate(:review, rating: 4, video: fringe)
      fringe_decorator = VideoDecorator.decorate(fringe.reload)

      expect(fringe_decorator.rating).to eq('4.0/5.0')
    end
  end
end
