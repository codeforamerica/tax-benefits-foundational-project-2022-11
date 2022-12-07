require 'rails_helper'

RSpec.describe Member, type: :model do
  context "creating member association to benefits app" do
    subject(:valid_member) { build :member, benefit_app: build(:benefit_app) }
    subject(:invalid_member_with_no_app) { build :member }
    subject(:invalid_member_with_no_first_name) { build :member_with_no_first_name }
    subject(:invalid_member_with_no_last_name) { build :member_with_no_last_name }
    subject(:invalid_member_with_no_date_of_birth) { build :member_with_no_date_of_birth }
    subject(:invalid_member_with_invalid_birthdate_format) { build :invalid_member_with_invalid_birthdate_format }

    # it "prints" do
    # puts valid_member.date_of_birth.class
    # end
    it { expect(valid_member).to be_valid }
    it { expect(invalid_member_with_no_app).not_to be_valid }
    it { expect(invalid_member_with_no_first_name).not_to be_valid }
    it { expect(invalid_member_with_no_last_name).not_to be_valid }
    it { expect(invalid_member_with_no_date_of_birth).not_to be_valid }
    it { expect(invalid_member_with_invalid_birthdate_format).not_to be_valid }
  end
end
