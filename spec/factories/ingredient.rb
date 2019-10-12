FactoryBot.define do
  factory :ingredient do
    sequence(:name) {|n| " name ingredient #{n}" }
    calories { "130" }

    trait :invalid do
      name { nil }
    end

    trait :new_name do
      name { 'New ingredient' }
    end
  end
end
