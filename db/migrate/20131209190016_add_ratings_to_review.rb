class AddRatingsToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :furnishings_rating, :integer
    add_column :reviews, :noise_rating, :integer
    add_column :reviews, :amenities_rating, :integer
    add_column :reviews, :transport_rating, :integer
  end
end
