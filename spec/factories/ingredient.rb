FactoryBot.define do
  factory :ingredient do
    name { 'rice' }
    calories { '130' }

    trait :invalid do
      name { nil }
    end
  end
end
