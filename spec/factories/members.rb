FactoryBot.define do
  factory :member do
    first_name { "MyString" }
    last_name { "MyString" }
    date_of_birth { "2022-12-06 15:19:47" }
    benefit_app { nil }
  end
end
