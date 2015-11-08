class Review < ActiveRecord::Base
  belongs_to :video, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :rating, :content
end
