require 'rails_helper'

RSpec.describe Member, type: :model do
  context "creating member association to benefits app" do
    subject(:valid_member) { create :member, benefit_app: create(:benefit_app) }
    subject(:invalid_member_with_no_benefit_app) { build :member, benefit_app: nil }
    subject(:invalid_member_with_no_first_name) { build :member_with_no_first_name }
    subject(:invalid_member_with_no_last_name) { build :member_with_no_last_name }
    subject(:invalid_member_with_no_date_of_birth) { build :member_with_no_date_of_birth }
    subject(:invalid_member_with_invalid_birthdate_format) { build :invalid_member_with_invalid_birthdate_format }
    subject(:invalid_member_with_invalid_ssn) { build(:invalid_member_with_invalid_ssn) }
    subject(:invalid_member_with_long_ssn) { build(:invalid_member_with_long_ssn) }
    subject(:invalid_member_with_short_ssn) { build(:invalid_member_with_short_ssn) }

    context "validations" do
      it { expect(valid_member).to be_valid }
      it { expect(invalid_member_with_no_benefit_app).not_to be_valid }
      it { expect(invalid_member_with_no_first_name).not_to be_valid }
      it { expect(invalid_member_with_no_last_name).not_to be_valid }
      it { expect(invalid_member_with_no_date_of_birth).not_to be_valid }
      it { expect(invalid_member_with_invalid_birthdate_format).not_to be_valid }
      it { expect(invalid_member_with_invalid_ssn).not_to be_valid }
      it { expect(invalid_member_with_long_ssn).not_to be_valid }
      it { expect(invalid_member_with_short_ssn).not_to be_valid }
    end

    it "gets the custom error message associated with invalid birth format" do
      invalid_member_with_no_date_of_birth.save
      expect(invalid_member_with_no_date_of_birth.errors.messages[:date_of_birth]).to include "Please use the date format (mm/dd/yyyy) or (yyyy-mm-dd)"
    end

    it "gets the field is required error message when no date of birth is included" do
      invalid_member_with_no_date_of_birth.save
      expect(invalid_member_with_no_date_of_birth.errors.messages[:date_of_birth]).to include "This field is required"
    end

    context "SSN number validation" do
      it "fails with too short of a number" do
        invalid_member_with_short_ssn.save
        expect(invalid_member_with_short_ssn.errors.messages[:ssn]).to include "The SSN is not 9 digits"
      end

      it "fails with too long of a number" do
        invalid_member_with_long_ssn.save
        expect(invalid_member_with_long_ssn.errors.messages[:ssn]).to include "The SSN is not 9 digits"
      end
    end
  end
end