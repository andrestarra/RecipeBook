FactoryBot.define do
  factory :step do
    operation { "MyString" }
    expected_minutes { 30.0 }
    comment { "MyString" }

    trait :invalid do
      operation { nil }
    end

    trait :new_operation do
      operation { "NewOperation" }
    end
  end
end
