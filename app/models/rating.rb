class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  
  validate :user_can_rate_only_once_per_post
  
  private
  
  def user_can_rate_only_once_per_post
    post = comment.post
    if post.ratings.exists?(user: user)
      errors.add(:base, "この投稿には既に評価済みです")
    end
  end
end
