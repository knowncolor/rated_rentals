class Address < ActiveRecord::Base
  include ValidationLogger

  has_many :reviews

  validates :street_number, presence: true
  validates :route, presence: true
  validates :postal_town, presence: true
  validates :postal_code, presence: true

  def formatted_address
    address_components = ["#{self.street_number} #{self.route}", self.postal_town]

    if (!self.flat_number.blank?)
      if self.flat_number.downcase.include? "flat"
        flat_description = self.flat_number
      else
        flat_description = "Flat #{self.flat_number}"
      end

      address_components.unshift(flat_description)
    end

    address_components.join(', ').titleize
  end
end
