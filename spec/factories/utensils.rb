FactoryBot.define do
  factory :utensil do
    sequence(:name) {|n| "name utensil #{n}" }

    trait :invalid do
      name { nil }
    end

    trait :new_name do
      name { 'New utensil' }
    end

    trait :old_name do
      name { 'Old name' }
    end
  end
end
