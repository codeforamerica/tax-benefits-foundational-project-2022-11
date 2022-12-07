FactoryBot.define do
  factory :benefit_app, class: BenefitApp do
    email_address { "test@codeforamerica.org" }
    address { "1000 Main Way, Left Of, A Country 10001" }
    phone_number { "8003934448" }
    association :primary_member, strategy: :build, factory: :member

    factory :benefit_app_without_email do
      email_address { "" }
    end

    factory :benefit_app_without_address do
      address { "" }
    end

    factory :benefit_app_without_phone_number do
      phone_number { "" }
    end

    factory :benefit_app_with_primary_member do
      primary_member { create(:member) }
    end
  end
end