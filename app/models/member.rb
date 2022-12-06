class Member < ApplicationRecord
  belongs_to :benefit_app
  validates :date_of_birth, presence: true
  validates :last_name, presence: true
  validates :first_name, presence: true 
end
