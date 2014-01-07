class AddCountryAndFlatToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :flat_number, :string
  end

  def self.down
    remove_column :addresses, :flat_number
  end
end
