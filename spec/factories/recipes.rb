FactoryBot.define do
  factory :recipe do
    source { "MyString" }
    location { "MyString" }
    total_minutes { 1.5 }

    trait :invalid do
      source { nil }
    end

    trait :new_source do
      source { "NewSource"}
    end
  end
end
