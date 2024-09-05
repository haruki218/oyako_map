class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one_attached :image
  

end