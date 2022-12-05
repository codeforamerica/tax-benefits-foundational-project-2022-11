class BenefitApp < ApplicationRecord
  validates :address, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true,
            format: { with: VALID_EMAIL_REGEX }
  validates :phone_number, presence: true
end