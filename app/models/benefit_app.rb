class BenefitApp < ApplicationRecord
  validates :address, presence: true
  validates :email_address, presence: true
  validates :phone_number, presence: true
end