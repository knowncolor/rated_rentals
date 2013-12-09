class AddDatesToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :start_date, :date
    add_column :reviews, :end_date, :date
  end
end
