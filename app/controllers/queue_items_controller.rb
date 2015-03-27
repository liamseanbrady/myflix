class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = QueueItem.where(user: current_user)
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user

    redirect_to my_queue_path
  end
  
  private

  def queue_video(video)
      QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video?(video)
  end

  def new_queue_item_position
    QueueItem.count + 1
  end

  def current_user_queued_video?(video)
    QueueItem.find_by(user: current_user, video: video)
  end
end
