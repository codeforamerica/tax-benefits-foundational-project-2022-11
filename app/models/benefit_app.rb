VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class BenefitApp < ApplicationRecord
  validates :address, presence: true
  validates :email_address, presence: true,
            format: { with: VALID_EMAIL_REGEX, message: "Please enter a valid email address" }
  validates :phone_number, presence: { message: "This field is required" }
  validates :submitted_at, presence: false

  has_one :primary_member, class_name: 'Member'

  def primary_member_name
    if primary_member.present?
      "#{primary_member.first_name} #{primary_member.last_name}"
    else
      "No Primary Member"
    end
  end
end