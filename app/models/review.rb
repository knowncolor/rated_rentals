class Review < ActiveRecord::Base
  validate :validate_start_date, :validate_end_date

  validates :street_number, presence: true
  validates :route, presence: true
  validates :postal_town, presence: true
  validates :postal_code, presence: true
  validates :start_date_before_type_cast, presence: true

  def validate_start_date
    # if the before type cast value is present we know it was not a valid date
    if (!start_date_before_type_cast.blank? && !start_date)
      errors.add(:start_date)
    end

    # blank before type cast means not present
    if (!start_date_before_type_cast)
      errors.add(:start_date, 'can\'t be blank')
    end

    # check date is not in the future
    errors.add(:start_date, 'cannot be in the future') if (start_date && start_date > Date.today)
  end

  def validate_end_date
    # if the before type cast value is present we know it was not a valid date
    if (!end_date_before_type_cast.blank? && !end_date)
      errors.add(:end_date)
    end

    # check date is not before the move in date
    errors.add(:end_date, 'can\'t be before the Moved In date') if (start_date && end_date && start_date > end_date)
  end
end