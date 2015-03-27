class ReviewsController < ApplicationController
  before_action :require_user

  def create
    review = Review.new(review_params)
    @video = Video.find(params[:video_id])
    review.video = @video
    review.author = current_user

    if review.save
      redirect_to @video 
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
