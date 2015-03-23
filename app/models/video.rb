class Video < ActiveRecord::Base
  belongs_to :category  
  has_many :reviews

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return none unless search_term.present?
    where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end
end
