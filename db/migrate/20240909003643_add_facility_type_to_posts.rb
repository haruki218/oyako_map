class AddFacilityTypeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :facility_type, :string
  end
end
