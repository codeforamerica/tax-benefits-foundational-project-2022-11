require 'rails_helper'

RSpec.describe BenefitApp, type: :model do
  context "validation of fields" do
    subject(:benefit_app_valid) { create :benefit_app }
    subject(:benefit_app_without_email) { build :benefit_app_without_email  }
    subject(:benefit_app_without_phone_number) { build :benefit_app_without_phone_number }
    subject(:benefit_app_without_address) { build :benefit_app_without_address }

    it "expects a email address to be present" do
       expect(benefit_app_without_email).not_to be_valid
    end

    it "expects a valid email address" do
      benefit_app = build :benefit_app, email_address: "@foo.com"
      expect(benefit_app).not_to be_valid

      benefit_app.email_address = "!!!@com.com"
      expect(benefit_app).not_to be_valid
      expect(benefit_app.save).to be_falsy
      expect(benefit_app.errors.messages[:email_address]).to include("Please enter a valid email address")

      benefit_app.email_address = "amanda89@codeforamerica.org"
      expect(benefit_app).to be_valid
    end

    it "expects a phone number to be present" do
     expect(benefit_app_without_phone_number).not_to be_valid
    end

    it "expects an address to be present" do
      expect(benefit_app_without_address).not_to be_valid
    end
  end
end
