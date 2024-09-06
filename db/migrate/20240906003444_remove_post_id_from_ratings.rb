class RemovePostIdFromRatings < ActiveRecord::Migration[6.1]
  def change
    remove_column :ratings, :post_id, :integer
  end
end
