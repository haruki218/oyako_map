class AddCommentIdToRatings < ActiveRecord::Migration[6.1]
  def change
    add_reference :ratings, :comment, foreign_key: true
  end
end
