class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_many :queue_items, ->{ order(:position) }

  has_secure_password validations: false

  def queued_video?(video)
    queue_items.find_by(user: self, video: video) ? true : false
  end
end

