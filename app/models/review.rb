class Review < ActiveRecord::Base

  validates :street_number, presence: true
  validates :route, presence: true
  validates :postal_town, presence: true
  validates :postal_code, presence: true
  validates :start_date, presence: true


  def start_date=(val)
    write_attribute :start_date, Date.strptime(val, '%m/%d/%Y') unless val.blank?
  end

  def end_date=(val)
    write_attribute :end_date, Date.strptime(val, '%m/%d/%Y') unless val.blank?
  end
end
