VALID_DATE_REGEX_1 = /\A\d{2}\/\d{2}\/\d{4}/
VALID_DATE_REGEX_2 = /^\d{4}-\d{2}-\d{2}$/
class Member < ApplicationRecord
  belongs_to :benefit_app
  validates :date_of_birth, presence: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validate :validate_birth_date_format

  def validate_birth_date_format
    if (not VALID_DATE_REGEX_1.match?(date_of_birth.to_s)) && (not VALID_DATE_REGEX_2.match?(date_of_birth.to_s))
      errors.add(:date_of_birth, "Please use the date format (mm/dd/yyyy) or (yyyy/mm/dd)")
    end
  end
end
