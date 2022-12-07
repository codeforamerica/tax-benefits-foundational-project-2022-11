FactoryBot.define do
  factory :member do
    first_name { "MyString" }
    last_name { "MyString" }
    date_of_birth { 29.years.ago }
    benefit_app { nil }

    factory :member_with_no_first_name do
      first_name { nil }
    end

    factory :member_with_no_last_name do
      last_name { nil }
    end

    factory :member_with_no_date_of_birth do
      date_of_birth { nil }
    end
  end
end