class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

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
    reviews.average(:rating).to_f.round(1) if reviews.any?
  end

  def as_indexed_json(options = {})
    as_json(
      only: [:title, :description],
      include: { 
        reviews: { only: [:content] } 
      },
      methods: :rating
    )
  end

  def self.search(term, options = {})
    search_definition = {
      query: {
        filtered: {
          query: {
            multi_match: {
              query: term,
              fields: ["title^100", "description^50"],
              operator: "and"
            }
          }
        }
      }
    }

    if term.present? && options[:reviews].present?
      search_definition[:query][:filtered][:query][:multi_match][:fields] << "reviews.content"
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:filter] = {
        range: {
          rating: {
            gte: (options[:rating_from] if options[:rating_from]),
            lte: (options[:rating_to] if options[:rating_to])
          }
        }
      }
    end

    __elasticsearch__.search search_definition
  end
end
