FactoryBot.define do
  factory :member do
    first_name { "MyString" }
    last_name { "MyString" }
    date_of_birth { 15.years.ago.to_date }
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

    factory :invalid_member_with_invalid_birthdate_format do
      date_of_birth {"284849-1-2"}
    end
  end
end
