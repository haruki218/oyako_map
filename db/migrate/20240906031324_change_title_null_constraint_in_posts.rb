class ChangeTitleNullConstraintInPosts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :posts, :title, true
  end
end
