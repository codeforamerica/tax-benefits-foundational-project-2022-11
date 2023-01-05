VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class BenefitApp < ApplicationRecord
  ELIGIBILITY_THRESHOLD_AMOUNT = 1_000
  validates :address, presence: { message: "This field is required" }
  validates :email_address, presence: { message: "This field is required" },
            format: { with: VALID_EMAIL_REGEX, message: "Please enter a valid email address" }
  validates :phone_number, presence: { message: "This field is required" }, length: { is: 10, message: "Please enter a valid phone number (area code + number)" }, numericality: { only_integer: true }
  validates :submitted_at, presence: false

  has_one :primary_member, -> { where(is_primary: true) }, class_name: 'Member', dependent: :destroy
  has_many :secondary_members, -> { where(is_primary: false) }, class_name: 'Member', dependent: :destroy

  def primary_member_name
    if primary_member.present?
      "#{primary_member.first_name} #{primary_member.last_name}"
    else
      "No Primary Member"
    end
  end

  def update_income(monthly_income)
    update({monthly_income: monthly_income}) && update_eligibility && reload
  end

  def compute_eligibility
    monthly_income < ELIGIBILITY_THRESHOLD_AMOUNT
  end

  def update_eligibility
    update({eligible: compute_eligibility})
  end
end
