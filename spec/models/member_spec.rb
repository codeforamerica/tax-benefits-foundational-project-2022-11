require 'rails_helper'

RSpec.describe Member, type: :model do
  context "creating member association to benefits app" do
    subject(:valid_member) { create :member }
    subject(:invalid_member_with_no_app) { build :member_without_app }
    subject(:invalid_member_with_no_first_name) { build :member_with_no_first_name }
    subject(:invalid_member_with_no_last_name) { build :member_with_no_last_name }
    subject(:invalid_member_with_no_date_of_birth) { build :member_with_no_date_of_birth }

    it { expect(valid_member).to be_valid }
    it { expect(invalid_member_with_no_app).not_to be_valid }
    it { expect(invalid_member_with_no_first_name).not_to be_valid }
    it { expect(invalid_member_with_no_last_name).not_to be_valid }
    it { expect(invalid_member_with_no_date_of_birth).not_to be_valid }

  end
end
