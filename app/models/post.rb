class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :ratings, through: :comments

  has_many_attached :images
  
  validates :address, presence: true
  geocoded_by :address
  after_validation :geocode
  
  # ソート用のスコープ
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :highly_rated, -> { 
    left_joins(comments: :ratings)
    .group(:id)
    .order(Arel.sql('COALESCE(AVG(ratings.score), 0) DESC'))
  }
  scope :most_commented, -> {
    left_joins(:comments)
    .group(:id)
    .order(Arel.sql('COUNT(comments.id) DESC'))
  }
  # 投稿に紐づくコメントの評価の平均を計算
  def average_rating
    ratings = comments.joins(:ratings).pluck(:score)
    return 0 if ratings.empty?
    ratings.sum.to_f / ratings.size
  end

  def self.search_for(content)
    Post.where("title LIKE ? OR address LIKE ?", "%#{content}%", "%#{content}%")
  end
end