FactoryBot.define do
  factory :use do
    quantity { 1 }
    measure { "MyString" }
    step { nil }
    ingredient { nil }
  end
end
