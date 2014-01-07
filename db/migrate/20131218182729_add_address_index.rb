class AddAddressIndex < ActiveRecord::Migration
  def change
    add_index :addresses, [:postal_code, :route, :street_number]
  end
end
