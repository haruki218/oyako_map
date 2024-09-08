class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  has_one_attached :image
  
  validates :address, presence: true
  
  # 投稿に紐づくコメントの評価の平均を計算
  def average_rating
    ratings = comments.joins(:ratings).pluck(:score)
    return 0 if ratings.empty?
    ratings.sum.to_f / ratings.size
  end

end