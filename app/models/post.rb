class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  
  enum post_type: { play: 0, facility: 1 }
end