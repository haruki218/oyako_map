class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :ratings, dependent: :destroy
end
