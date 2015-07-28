class User < ActiveRecord::Base
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_many :queue_items, ->{ order(:position) }
  has_many :reviews, ->{ order(created_at: :desc) }
  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'

  has_secure_password validations: false

  before_create :generate_token!

  def queued_video?(video)
    queue_items.find_by(user: self, video: video) ? true : false
  end

  def follows?(another_user)
    following_relationships.where(leader: another_user).present?
  end

  def can_follow?(another_user)
    !(another_user == self || follows?(another_user))
  end
  
  def generate_token!
    self.token = SecureRandom.urlsafe_base64
  end
end

