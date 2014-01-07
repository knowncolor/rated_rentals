class Address < ActiveRecord::Base

  has_many :reviews

  validates :street_number, presence: true
  validates :route, presence: true
  validates :postal_town, presence: true
  validates :postal_code, presence: true
end
