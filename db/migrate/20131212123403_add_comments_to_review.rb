class AddCommentsToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :building_comments, :string
    add_column :reviews, :furnishings_comments, :string
    add_column :reviews, :noise_comments, :string
    add_column :reviews, :amenities_comments, :string
    add_column :reviews, :transport_comments, :string
  end
end
