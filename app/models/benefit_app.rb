VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

class BenefitApp < ApplicationRecord
  validates :address, presence: true
  validates :email_address, presence: true,
            format: { with: VALID_EMAIL_REGEX }
  validates :phone_number, presence: true

  has_one :primary_member, class_name: 'Member'
end