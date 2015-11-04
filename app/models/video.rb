class Video < ActiveRecord::Base
  include Elasticsearch::Model
  index_name ['myflix', Rails.env].join('_')

  belongs_to :category  
  has_many :reviews

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates_presence_of :title, :description, :video_url

  def self.search_by_title(search_term)
    return none unless search_term.present?
    where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end

  def rating
    reviews.average(:rating).round(1) if reviews.any?
  end

  def as_indexed_json(options = {})
    as_json(only: [:title, :description])
  end

  def self.search(term)
    __elasticsearch__.search(term).records.to_a
  end
end
