FactoryBot.define do
  factory :benefit_app, class: BenefitApp do
    email_address { "test@codeforamerica.org" }
    address { "1000 Main Way, Left Of, A Country 10001" }
    phone_number { "8003934448" }
    primary_member { nil }
    secondary_members { [] }

    factory :benefit_app_without_email do
      email_address { "" }
    end

    factory :benefit_app_without_address do
      address { "" }
    end

    factory :benefit_app_without_phone_number do
      phone_number { "" }
    end

    factory :benefit_app_with_invalid_phone_number do
      phone_number { "3010000" }
    end

    factory :benefit_app_with_primary_member do
      primary_member { create(:primary_member) }
    end

    factory :benefit_app_with_non_primary_member do
      primary_member { build(:member, is_primary: false)}
    end
  end
end