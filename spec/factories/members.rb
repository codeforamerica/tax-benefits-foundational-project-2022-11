FactoryBot.define do
  factory :member do
    sequence(:first_name) { |n| "MemberNumber#{n}" }
    sequence(:last_name) { |n| "LastNameOfMemberNumber#{n}" }
    date_of_birth { 29.years.ago.strftime("%m/%d/%Y") }
    is_primary { false }
    benefit_app { build(:benefit_app) }

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

    factory :primary_member do
      sequence(:first_name) { |n| "PrimaryMemberNumber#{n}" }
      sequence(:last_name) { |n| "LastNameOfPrimaryMemberNumber#{n}" }
      is_primary { true }
    end

    factory :secondary_member do
      sequence(:first_name) { |n| "SecondaryMemberNumber#{n}" }
      sequence(:last_name) { |n| "LastNameOfSecondaryMemberNumber#{n}" }
      is_primary { false }
    end
  end
end
