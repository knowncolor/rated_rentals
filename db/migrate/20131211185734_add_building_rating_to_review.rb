class AddBuildingRatingToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :building_rating, :integer
  end
end
