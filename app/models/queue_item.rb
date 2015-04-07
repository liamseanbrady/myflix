class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true 

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def rating
    review.present? ? review.rating : ''
  end

  def rating=(new_rating)
    if review
      review.update_attribute(:rating, new_rating)
    else
      new_review = Review.new(author: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

  private

  def review
    @review ||= video.reviews.find_by(author: user)
  end
end
