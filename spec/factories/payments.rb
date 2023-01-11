FactoryBot.define do
  factory :transaction do
    checkout_session_id { "MyString" }
    payment_intent { "MyString" }
  end
end
