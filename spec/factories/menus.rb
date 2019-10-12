FactoryBot.define do
  factory :menu do
    sequence(:name) {|n| "name menu #{n}" }
    type_menu { "MyString" }

    trait :invalid do
      name { nil }
    end

    trait :new_name do
      name { 'New menu' }
    end
  end
end
