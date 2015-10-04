class Video < ActiveRecord::Base
  belongs_to :category  
  has_many :reviews

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description, :video_url

  def self.search_by_title(search_term)
    return none unless search_term.present?
    where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end
end
