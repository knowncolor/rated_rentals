class AddAddressIdToReview < ActiveRecord::Migration
  def self.up
    add_column :reviews, :address_id, :integer
  end

  def self.down
    remove_column :reviews, :address_id
  end
end
