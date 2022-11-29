require 'rails_helper'

RSpec.describe BenefitApp, type: :model do
  context "validation of fields" do
    subject(:benefit_app_valid) { create :benefit_app }
    subject(:benefit_app_without_email) { expect { create :benefit_app_without_email } }
    subject(:benefit_app_without_phone_number) { expect { create :benefit_app_without_phone_number } }
    subject(:benefit_app_without_address) { expect { create :benefit_app_without_address } }

    it { benefit_app_without_email.to raise_error(/Email/) }
    it { benefit_app_without_phone_number.to raise_error(/Phone number/) }
    it { benefit_app_without_address.to raise_error(/Address/) }
  end
end
