VALID_DATE_REGEX_1 = /\A\d{2}\/\d{2}\/\d{4}/
VALID_DATE_REGEX_2 = /^\d{4}-\d{2}-\d{2}$/
class Member < ApplicationRecord
  belongs_to :benefit_app
  # This is made deterministic to support the unique index on it.
  encrypts :ssn, deterministic: true
  validates :date_of_birth, presence: { message: "This field is required" }
  validates :last_name, presence: { message: "This field is required" }
  validates :first_name, presence: { message: "This field is required" }
  validate :validate_birth_date_format
  validates :is_primary, inclusion: { in: [ true, false ] }
  validates :ssn, presence: { message: "This field is required" },
            uniqueness: true,
            length: { is: 9, message: "The SSN is not 9 digits" }

  def validate_birth_date_format
    if (not VALID_DATE_REGEX_1.match?(date_of_birth.to_s)) && (not VALID_DATE_REGEX_2.match?(date_of_birth.to_s))
      errors.add(:date_of_birth, "Please use the date format (mm/dd/yyyy) or (yyyy-mm-dd)")
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
