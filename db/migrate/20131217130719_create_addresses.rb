class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_number
      t.string :route
      t.string :postal_town
      t.string :postal_code
      t.string :country
      t.string :decimal_degrees_latitude
      t.string :decimal_degrees_longitude

      t.timestamps
    end
  end
end
