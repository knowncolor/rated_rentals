class Review < ActiveRecord::Base
  include ValidationLogger

  belongs_to :address
  belongs_to :user

  accepts_nested_attributes_for :address

  validate :validate_start_date, :validate_end_date

  validates :start_date_before_type_cast, presence: true
  validates :address, presence: true
  validates :user, presence: true
  validates :building_rating, :inclusion => 1..10
  validates :furnishings_rating, :inclusion => 1..10
  validates :noise_rating, :inclusion => 1..10
  validates :amenities_rating, :inclusion => 1..10
  validates :transport_rating, :inclusion => 1..10

  def descriptions_word_count
    building_comments.split.size +
        furnishings_comments.split.size +
        noise_comments.split.size +
        amenities_comments.split.size +
        transport_comments.split.size
  end

  def is_owner?(user)
    user.id == self.user_id
  end

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