FactoryBot.define do
  factory :step do
    operation { "MyString" }
    schedule_time { 30.0 }
    comment { "MyString" }

    trait :invalid do
      operation { nil }
    end
  end
end
