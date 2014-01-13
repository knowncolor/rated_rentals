class Address < ActiveRecord::Base

  has_many :reviews

  validates :street_number, presence: true
  validates :route, presence: true
  validates :postal_town, presence: true
  validates :postal_code, presence: true

  def formatted_address
    address_components = ["#{self.street_number} #{self.route}", self.postal_town, self.postal_code]

    if (!self.flat_number.blank?)
      address_components.unshift(self.flat_number)
    end

    address_components.join(', ')
  end
end
