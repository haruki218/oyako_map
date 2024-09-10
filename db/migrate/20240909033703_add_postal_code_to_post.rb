class AddPostalCodeToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :postal_code, :string
  end
end
