require 'rails_helper'

RSpec.describe BenefitApp, type: :model do
  context "validation of fields" do
    subject(:benefit_app_valid) { create :benefit_app }
    subject(:benefit_app_without_email) { build :benefit_app_without_email  }
    subject(:benefit_app_without_phone_number) { build :benefit_app_without_phone_number }
    subject(:benefit_app_without_address) { build :benefit_app_without_address }
    subject(:benefit_app_with_invalid_phone_number) { build :benefit_app_with_invalid_phone_number }
    subject(:benefit_app_with_primary_member) { create(:benefit_app, primary_member: build(:member, is_primary: true))}
    subject(:benefit_app_with_non_primary_member) { build :benefit_app_with_non_primary_member }

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

    it "expects a valid phone number" do
      expect(benefit_app_with_invalid_phone_number).not_to be_valid
    end
    it "expects an address to be present" do
      expect(benefit_app_without_address).not_to be_valid
    end

    it "expects its primary member to be marked as one" do
      expect(benefit_app_with_primary_member.primary_member.is_primary).to be_truthy
    end

    it "does not assign a non-primary member as primary" do
      expect(benefit_app_with_non_primary_member.primary_member_id).to be_nil
    end
  end
end
