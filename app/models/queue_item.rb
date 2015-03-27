class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def rating
    review = video.reviews.find_by(author: user)
    review.present? ? review.rating : ''
  end

  def category_name
    category.name
  end
end
