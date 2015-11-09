class VideosController < ApplicationController
  before_action :require_user

  def index 
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  def advanced_search
    respond_to do |format|
      format.html
      format.js do
        query = params[:query]
        options = {
          reviews: params[:reviews],
          rating_from: params[:rating_from],
          rating_to: params[:rating_to]
        }
        @videos = Video.search(query, options).records.to_a
        @result_count = @videos.count
        render layout: false, content_type: 'text/javascript'
      end
    end
  end
end
