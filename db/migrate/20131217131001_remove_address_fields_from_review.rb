class RemoveAddressFieldsFromReview < ActiveRecord::Migration
  def self.up
    remove_column :reviews, :street_number
    remove_column :reviews, :route
    remove_column :reviews, :postal_town
    remove_column :reviews, :postal_code
    remove_column :reviews, :decimal_degrees_latitude
    remove_column :reviews, :decimal_degrees_longitude
  end

  def self.down
    add_column :reviews, :street_number, :string
    add_column :reviews, :route, :string
    add_column :reviews, :postal_town, :string
    add_column :reviews, :postal_code, :string
    add_column :reviews, :decimal_degrees_latitude, :string
    add_column :reviews, :decimal_degrees_longitude, :string
  end
end
