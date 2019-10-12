FactoryBot.define do
  factory :plate do
    sequence(:name) {|n| " name #{n}" }
    main_ingredient { "MyString" }
    type_plate { "MyString" }
    price { 1.5 }
    comment { "MyString" }

    trait :invalid do
      name { nil }
    end

    trait :new_name do
      name { 'New plate' }
    end
  end
end
